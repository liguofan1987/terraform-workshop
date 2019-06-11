# terraform-workshop

## This program is to create below infrastructure.
![infrastructure](https://opensource-cisco-com.s3-us-west-2.amazonaws.com/terraform-pictures/infrastructure.png)

## Installation (https://learn.hashicorp.com/terraform/getting-started/install.html)

## How to run?

### Customize
#### AWS Configure
Set your AWS access key and secret key
```
$ aws configure
AWS Access Key ID [None]: 
AWS Secret Access Key [None]: 
Default region name [None]: 
Default output format [None]: 
```

#### Decrypt
```
$ ./decrypt.sh ciscolive.pem.enc
$ chmod 600 ciscolive.pem
$ ./decrypt.sh variables.tf.enc 
```

#### Set Parameters

Set aws_cluster_name, AWS_DEFAULT_REGION and AWS_SSH_KEY_NAME
```
$ vi terraform.tfvars 
#Global Vars
aws_cluster_name = "steven"

#EC2 SSH Key Name
AWS_SSH_KEY_NAME = "******"

#AWS Region
AWS_DEFAULT_REGION = "******"
```

Use the key pair set before and set instance AMI.
```
$ #replace ciscolive.pem with your praviate key.

$ vi variables.tf 
...
data "aws_ami" "webnode" {
  most_recent = true

  filter {
    name   = "name"
    values = ["******"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["******"] 
}
```

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
