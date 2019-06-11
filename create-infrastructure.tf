provider "aws" {
    region = "${var.AWS_DEFAULT_REGION}"
}

data "aws_availability_zones" "available" {}

/*
* Calling modules who create the initial AWS VPC and AWS ELB
*/

module "aws-vpc" {
  source = "./modules/vpc"
  aws_cluster_name = "${var.aws_cluster_name}"
  aws_vpc_cidr_block = "${var.aws_vpc_cidr_block}"
  aws_avail_zones="${slice(data.aws_availability_zones.available.names,0,2)}"
  aws_cidr_subnets_private="${var.aws_cidr_subnets_private}"
  aws_cidr_subnets_public="${var.aws_cidr_subnets_public}"
  default_tags="${var.default_tags}"

}

module "aws-elb" {
  source = "./modules/elb"
  aws_cluster_name="${var.aws_cluster_name}"
  aws_vpc_id="${module.aws-vpc.aws_vpc_id}"
  aws_avail_zones="${slice(data.aws_availability_zones.available.names,0,2)}"
  aws_subnet_ids_public="${module.aws-vpc.aws_subnet_ids_public}"
  aws_elb_port = "${var.aws_elb_port}"
  web_node_port = "${var.web_node_port}"
  default_tags="${var.default_tags}"

}

/*
* Create Bastion Instances in AWS
*
*/

resource "aws_instance" "bastion-server" {
    ami = "${data.aws_ami.bastion.id}"
    instance_type = "${var.aws_bastion_size}"
    count = "${var.aws_bastion_num}"
    associate_public_ip_address = true
    availability_zone  = "${element(slice(data.aws_availability_zones.available.names,0,2),count.index)}"
    subnet_id = "${element(module.aws-vpc.aws_subnet_ids_public,count.index)}"
    vpc_security_group_ids = [ "${module.aws-vpc.aws_security_group}", "${module.aws-vpc.aws_security_group_allow_ssh}" ]
    key_name = "${var.AWS_SSH_KEY_NAME}"
    root_block_device {
        delete_on_termination = "true"
    }
    tags = "${merge(var.default_tags, map(
      "Name", "${var.aws_cluster_name}-bastion-${count.index}",
      "Cluster", "${var.aws_cluster_name}",
      "Role", "bastion-${var.aws_cluster_name}-${count.index}"
    ))}"
}


/*
* Create Web Nodes
*
*/

resource "aws_instance" "web-node" {
    ami = "${data.aws_ami.webnode.id}"
    instance_type = "${var.aws_web_node_size}"
    count = "${var.aws_web_node_num}"
    availability_zone  = "${element(slice(data.aws_availability_zones.available.names,0,2),count.index)}"
    subnet_id = "${element(module.aws-vpc.aws_subnet_ids_private,count.index)}"
    vpc_security_group_ids = [ "${module.aws-vpc.aws_security_group}" ]
    key_name = "${var.AWS_SSH_KEY_NAME}"
    root_block_device {
        volume_size = "${var.aws_web_node_root_volumn_size}"
        delete_on_termination = "true"
    }
    tags = "${merge(var.default_tags, map(
      "Name", "${var.aws_cluster_name}-webnode${count.index}",
      "Cluster/${var.aws_cluster_name}", "member",
      "Role", "Web"
    ))}"
    lifecycle {
      create_before_destroy = true 
      ignore_changes = ["tags"]
    }
}

resource "aws_elb_attachment" "attach_web_nodes" {
  count = "${var.aws_web_node_num}"
  depends_on = ["aws_instance.web-node"]
  elb      = "${module.aws-elb.aws_elb_web_id}"
  instance = "${element(aws_instance.web-node.*.id,count.index)}"
  lifecycle {
      create_before_destroy = true
    }
}


/*
* Create Cloud Hosts File
*
*/
data "template_file" "inventory" {
    template = "${file("${path.module}/templates/inventory.tpl")}"

    vars {
        public_ip_address_bastion = "${join("\n",formatlist("bastion ansible_host=%s ansible_user=%s ansible_user_id=%s", aws_instance.bastion-server.*.public_ip, var.vm_default_user, var.vm_default_user))}"
        connection_strings_webnodes = "${join("\n",formatlist("%s ansible_host=%s ansible_user=%s ansible_user_id=%s", aws_instance.web-node.*.tags.Name, aws_instance.web-node.*.private_ip, var.vm_default_user, var.vm_default_user))}"

        list_webnodes = "${join("\n",aws_instance.web-node.*.tags.Name)}"
        elb_web_fqdn = "web_loadbalancer_domain_name=\"${module.aws-elb.aws_elb_web_fqdn}\""
    }

}

resource "null_resource" "inventories" {
  provisioner "local-exec" {
      command = "echo '${data.template_file.inventory.rendered}' > ./hosts"
  }

  triggers {
      template = "${data.template_file.inventory.rendered}"
  }

}

