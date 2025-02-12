#1.Create node instance
module "node_exporter" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.devops.id
  name = local.resource_name

  instance_type          = "t3.micro"
  vpc_security_group_ids = [local.node_exporter_sg_id]
  subnet_id              = local.node_exporter_subnet_id

  tags = merge(
    var.common_tags,
    var.node_tags,
        {
          Name = local.resource_name
        }
  )
}

#2.Create NUll resource to run Ansible playbook through remote provisioner.
#The null_resource resource implements the standard resource lifecycle but takes no further action.
resource "null_resource" "backend" {
  # Changes to id of instance tehn requires re-provisioning
  triggers = {
    instance_id = module.node_exporter.id     #means when backend instance id creates, then only it will trigger apply
  }

  # So we just choose the first in this case
  connection {
    host = module.node_exporter.private_ip    #to connect backend instance
    type = "ssh"
    user = "ec2-user"
    password = "DevOps321"
  }

  # Copies the myapp.conf file to /etc/myapp.conf
  provisioner "file" {
    source      = "${var.backend_tags.Component}.sh"    #backend.sh
    destination = "/tmp/backend.sh"     #backend.sh file copies to tmp folder
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/backend.sh",   #modifying permision
      "sudo sh /tmp/backend.sh ${var.backend_tags.Component} ${var.environment}"    #sudo sh /tmp/backend.sh backend dev (#arg1 agr2)
    ]
  }
}


#3.Stop ec2 instance
resource "aws_ec2_instance_state" "backend" {
  instance_id = module.backend.id
  state       = "stopped"
  depends_on = [null_resource.backend]     # If we apply, terraform automatically run all resources parallelly right. So put depends_on. Then it will only runs once the previous one completed
}


#4.Create AMI from stopped instances
resource "aws_ami_from_instance" "backend" {
  name               = local.resource_name
  source_instance_id = module.backend.id
  depends_on = [aws_ec2_instance_state.backend]
}


#5.Delete the instance using NULL RESOURCE, beacuse DELETE option for insatnce is not there.
resource "null_resource" "backend_delete" {
  # Changes to any instance of the cluster requires re-provisioning
  triggers = {
    instance_id = module.backend.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${module.backend.id}"
    # command = "aws ec2 terminate-instances --instance-ids ${instance_id}"

    # environment = {
    #   instance_id = module.backend.id
    # }
  }

  depends_on = [aws_ami_from_instance.backend]
}