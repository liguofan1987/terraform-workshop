output "bastion_ip" {
    value = "${join("\n", aws_instance.bastion-server.*.public_ip)}"
}

output "webnodes" {
    value = "${join("\n", aws_instance.web-node.*.private_ip)}"
}

output "aws_elb_web_fqdn" {
    value = "${module.aws-elb.aws_elb_web_fqdn}:${var.aws_elb_port}"
}

#output "inventory" {
#    value = "${data.template_file.inventory.rendered}"
#}

output "default_tags" {
    value = "${var.default_tags}"
}
