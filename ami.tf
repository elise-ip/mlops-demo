// TERRAFORM SCRIPT - Pull in Deep Learning Pytorch AMI, deploy to EC2 with Security Group


// Configure the AWS Provider
provider "aws" {
  region = "us-west-1"
}

// Pull in data source of Deep Learning AMI
data "aws_ami" "dl_pytorch_ami" {
   most_recent = true
   owners =  ["aws-marketplace"]

   filter {
    name = "name"
    values = ["*PyTorch*"]
   }
}

resource "aws_security_group" "dl_pytorch_allow_http_ssh" {
    name        = "_allow_http_ssh"
    description = "Allow HTTP and SSH inbound traffic and all outbound traffic"

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.dl_pytorch_ami.id}"
  instance_type = "t3.micro"
  security_groups = ["${aws_security_group.dl_pytorch_allow_http_ssh.name}"]
  # key_name = ""
}