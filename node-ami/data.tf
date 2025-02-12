#Taking 
data "aws_ami" "devops" {
  most_recent      = true
  owners = ["973714476881"] #copy from AWS Account

  filter {
    name   = "name"
    values = ["RHEL-9-DevOps-Practice"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
