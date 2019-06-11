variable "aws_cluster_name" {
    description = "Name of Cluster"
}

variable "aws_vpc_id" {
    description = "AWS VPC ID"
}

variable "aws_elb_port" {
    description = "Port for AWS ELB"
}

variable "web_node_port" {
    description = "Port for Web node"
}


variable "aws_avail_zones" {
    description = "Availability Zones Used"
    type = "list"
}


variable "aws_subnet_ids_public" {
    description = "IDs of Public Subnets"
    type = "list"
}


variable "default_tags" {
    description = "Tags for all resources"
    type = "map"
}
