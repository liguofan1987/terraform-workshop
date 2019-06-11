output "aws_elb_web_id" {
    value = "${aws_elb.aws-elb-web.id}"
}

output "aws_elb_web_fqdn" {
    value = "${aws_elb.aws-elb-web.dns_name}"
}

