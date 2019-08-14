# terraform-ec2
This Terraform code will create a single AWS ec2 instance in the specified region and upload the specified file to the `/tmp` folder of the new instance. 

## Requisite Information
* [AWS Region Name](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)
* [AWS Instance Type](https://aws.amazon.com/ec2/instance-types/)
* AWS Credentials (Access Key & Secret Key)
* Filename to upload

By default, Terraform will prompt for this information but you can specify it beforehand by creating a file named `terraform.tfvars` in the same directory with the below format and filling in the values:

```
aws_region = ""
instance_type = ""
instance_name = ""
aws_access_key = ""
aws_secret_key = ""
upload_filename = ""
```

## Usage
* Install Terraform
  * Instructions can be found [here](https://learn.hashicorp.com/terraform/getting-started/install.html) to install Terraform
* Clone this repository
* Navigate to directory for this cloned repository
* `terraform init`
* `terraform plan -out tf.out`
  * Enter any variables you didn't specify in the `terraform.tfvars` file
* `terraform apply tf.out`

## Assumptions & Caveats
* This code uses the [official CentOS AMI](https://aws.amazon.com/marketplace/pp/B00O7WM7QW) with a hardcoded AMI ID.
* As such, the default user to copy the file over is `centos` per the AMI's documentation.
* The ssh connection to copy the file also assumes the private ssh key to connect to this instance is at `~/.ssh/id_rsa`.
* Accordingly, the public key uploaded to this instance is hardcoded to `~/.ssh/id_rsa.pub`.
* The `.gitignore` file ignores the `terraform.tfvars` file so that, if specified, credentials are not committed to source countrol.
* The security groups applied to this instance allow connections via ssh from _any_ ip addresses. Apply with caution. 
* At this time, the file to upload must come from within the working directory (i.e. `./filename`) and be specified as `filename` or `test.file` without the `./`