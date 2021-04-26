locals {
  private_key_path = "/home/rubo/aws-demo777.pem"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-2"
  access_key = "   "
  secret_key = "   "
  #profile                 = "default"
}


resource "aws_instance" "myec2" {
  ami                    = "ami-08962a4068733a2b6"
  instance_type          = "t2.micro"
  key_name               = "aws-demo777"
  security_groups = [ aws_security_group.ec2.name ]
}
resource "local_file" "inventory" {
  content = templatefile("inventory.template",
    {
      public_ip = aws_instance.myec2.public_ip
    }
  )
  filename = "inventory"
}
resource "time_sleep" "wait" {
  depends_on = [aws_instance.myec2]

  create_duration = "230s"
}
resource "null_resource" "runansible" {
  provisioner "local-exec" {
    command = "ansible-playbook -i inventory playbook.yml"

  }
  depends_on = [time_sleep.wait]
}
 
  
  
