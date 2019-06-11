#Set your vpc,subnet,security group, lb and cluster name
aws_cluster_name = "steven"

#EC2 SSH Key Name
AWS_SSH_KEY_NAME = "privatekey.pem"

#AWS Region
AWS_DEFAULT_REGION = "ca-central-1"

#VPC Vars
aws_vpc_cidr_block = "10.10.0.0/21"
aws_cidr_subnets_private = ["10.10.2.0/24","10.10.3.0/24"]
aws_cidr_subnets_public = ["10.10.0.0/24","10.10.1.0/24"]

#Bastion Host
aws_bastion_num = 1
aws_bastion_size = "t2.micro"

#Web Cluster

aws_web_node_num = 2
aws_web_node_size = "t2.micro"
aws_web_node_root_volumn_size = 10

#Settings AWS ELB

aws_elb_port = 80
web_node_port = 80


default_tags = {
  Env = "devnet-ciscolive"
  Product = "San Diego"
}

vm_default_user = "centos"

