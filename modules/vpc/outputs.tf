output "aws_vpc_id" {
    value = "${aws_vpc.ciscolive-vpc.id}"
}

output "aws_subnet_ids_private" {
    value = ["${aws_subnet.ciscolive-vpc-subnets-private.*.id}"]
}

output "aws_subnet_ids_public" {
    value = ["${aws_subnet.ciscolive-vpc-subnets-public.*.id}"]
}

output "aws_security_group" {
    value = ["${aws_security_group.vpc-cluster-sg.*.id}"]
}

output "aws_security_group_allow_ssh" {
    value = ["${aws_security_group.allow-ssh.*.id}"]
}

output "default_tags" {
    value = "${var.default_tags}"
}

