variable "AWS_SSH_KEY_NAME" {
  description = "Name of the SSH keypair to use in AWS."
}

variable "AWS_DEFAULT_REGION" {
  description = "AWS Region"
}

//General Cluster Settings

variable "aws_cluster_name" {
  description = "Name of AWS Cluster"
}

data "aws_ami" "bastion" {
  most_recent = true

  filter {
    name   = "name"
    #### Set your AMI name ending with * (Wildcard)####
    values = ["YOUR AMI NAME*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  #### Set your AWS Account ID below ####
  owners = ["YOUR ACCOUNT ID"] #DevNet Team
}

data "aws_ami" "webnode" {
  most_recent = true

  filter {
    name   = "name"
    #### Set your AMI name ending with * (Wildcard)####
    values = ["YOUR AMI NAME*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  #### Set your AWS Account ID below #####
  owners = ["YOUR ACCOUNT ID"] #DevNet Team
}
//AWS VPC Variables

variable "aws_vpc_cidr_block" {
  description = "CIDR Block for VPC"
}

variable "aws_cidr_subnets_private" {
  description = "CIDR Blocks for private subnets in Availability Zones"
  type = "list"
}

variable "aws_cidr_subnets_public" {
  description = "CIDR Blocks for public subnets in Availability Zones"
  type = "list"
}

//AWS EC2 Settings

variable "aws_bastion_num" {
    description = "Number of Bastion Host"
}

variable "aws_bastion_size" {
    description = "EC2 Instance Size of Bastion Host"
}



/*
* AWS EC2 Settings
* The number should be divisable by the number of used
* AWS Availability Zones without an remainder.
*/
variable "aws_web_node_num" {
    description = "Number of Web Nodes"
}

variable "aws_web_node_size" {
    description = "Instance size of Web Nodes"
}

variable "aws_web_node_root_volumn_size" {
    description = "EC2 Instance Root Storage Size of Web Nodes"
}


/*
* AWS ELB Settings
*
*/
variable "aws_elb_port" {
    description = "Port for AWS ELB"
}

variable "web_node_port" {
    description = "Port of Web node"
}

variable "default_tags" {
  description = "Default tags for all resources"
  type = "map"
}

/*
* VM Default User
*
*/
#### Change the default user based on your OS ####
variable "vm_default_user" {
    type = "string"
    default = "centos"
    description = "Default user to SSH into VM"
}


