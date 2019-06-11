# terraform-workshop

## This program is to create below infrastructure.
![infrastructure](https://opensource-cisco-com.s3-us-west-2.amazonaws.com/terraform-pictures/infrastructure.png)

## Installation (https://learn.hashicorp.com/terraform/getting-started/install.html)

## Customize the program
### AWS Configure
Set your AWS access key and secret key
```
$ aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]: 
```

### Set Parameters

Set your aws_cluster_name, AWS_DEFAULT_REGION, AWS_SSH_KEY_NAME and vm_default_user based on OS.
```
$ vi terraform.tfvars 
#Set your vpc,subnet,security group, lb and cluster name
aws_cluster_name = "******"

#EC2 SSH Key Name
AWS_SSH_KEY_NAME = "******"

#AWS Region
AWS_DEFAULT_REGION = "******"
...
vm_default_user = "******"
```
Set your AMI NAME with wildcard and Account ID, Make sure the webnode image has enabled web app and listen to 80 port or you can change the port in terraform.tfvars.
```
$ vi variables.tf 
...
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

```

### output.tf define the "terraform apply" output

## Run the Program

### Initialize
```
$ terraform init
```

### Validate syntax
```
$ terraform validate 
```

### Plan
```
$ terraform plan
```

### Apply
This command create resources and generated files:
hosts ###for ansible use
terraform.tfstate ### make it safe to track the state

```
$ terraform apply
...
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
...
```

### Destroy
```
$ terraform destroy
...
Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes
...
```

## Do CiscoLive Lab
https://developer.cisco.com/docs/terraform-workshop/#!getting-started/installation
