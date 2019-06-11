resource "aws_vpc" "ciscolive-vpc" {
    cidr_block = "${var.aws_vpc_cidr_block}"

    #DNS Related Entries
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = "${merge(var.default_tags, map(
      "Name", "${var.aws_cluster_name}-vpc"
    ))}"
}


resource "aws_internet_gateway" "ciscolive-vpc-internetgw" {
  vpc_id = "${aws_vpc.ciscolive-vpc.id}"
  tags = "${merge(var.default_tags, map(
    "Name", "${var.aws_cluster_name}-internetgw"
  ))}"
}

resource "aws_subnet" "ciscolive-vpc-subnets-public" {
    vpc_id = "${aws_vpc.ciscolive-vpc.id}"
    count = "${length(var.aws_cidr_subnets_public) < length(var.aws_avail_zones) ? length(var.aws_cidr_subnets_public) : length(var.aws_avail_zones)}"
    availability_zone = "${element(var.aws_avail_zones, count.index)}"
    cidr_block = "${element(var.aws_cidr_subnets_public, count.index)}"

    tags = "${merge(var.default_tags, map(
      "Name", "${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-public",
      "cluster/${var.aws_cluster_name}", "member"
    ))}"
}


resource "aws_subnet" "ciscolive-vpc-subnets-private" {
    vpc_id = "${aws_vpc.ciscolive-vpc.id}"
    count = "${length(var.aws_cidr_subnets_public) < length(var.aws_avail_zones) ? length(var.aws_cidr_subnets_public) : length(var.aws_avail_zones)}"
    availability_zone = "${element(var.aws_avail_zones, count.index)}"
    cidr_block = "${element(var.aws_cidr_subnets_private, count.index)}"

    tags = "${merge(var.default_tags, map(
      "Name", "${var.aws_cluster_name}-${element(var.aws_avail_zones, count.index)}-private"
    ))}"
}

#Routing in VPC

#TODO: Do we need two routing tables for each subnet for redundancy or is one enough?

resource "aws_route_table" "vpc-public" {
    vpc_id = "${aws_vpc.ciscolive-vpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.ciscolive-vpc-internetgw.id}"
    }

    tags = "${merge(var.default_tags, map(
      "Name", "${var.aws_cluster_name}-routetable-public"
    ))}"
}

resource "aws_route_table_association" "vpc-public" {
    count = "${length(var.aws_cidr_subnets_public) < length(var.aws_avail_zones) ? length(var.aws_cidr_subnets_public) : length(var.aws_avail_zones)}"
    subnet_id = "${element(aws_subnet.ciscolive-vpc-subnets-public.*.id,count.index)}"
    route_table_id = "${aws_route_table.vpc-public.id}"
}


# Security Groups

resource "aws_security_group" "vpc-cluster-sg" {
    name = "${var.aws_cluster_name}-securitygroup"
    vpc_id = "${aws_vpc.ciscolive-vpc.id}"

    tags = "${merge(var.default_tags, map(
      "Name", "${var.aws_cluster_name}-securitygroup"
    ))}"
}

resource "aws_security_group_rule" "allow-all-ingress-within-vpc" {
    type = "ingress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks= ["${var.aws_vpc_cidr_block}"]
    security_group_id = "${aws_security_group.vpc-cluster-sg.id}"
}

resource "aws_security_group_rule" "allow-all-egress" {
    type = "egress"
    from_port = 0
    to_port = 65535
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = "${aws_security_group.vpc-cluster-sg.id}"
}


resource "aws_security_group" "allow-ssh" {
    name = "ssh-connection"
    description = "Allow SSH Connection"
    vpc_id = "${aws_vpc.ciscolive-vpc.id}"

    ingress { # TCP
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = "${merge(var.default_tags, map(
        "Name", "allow-ssh"
    ))}"
}
