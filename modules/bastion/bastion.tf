resource "aws_security_group" "bastion_ssh" {
  name = "octatine-bastion-ssh"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.cidr_blocks
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    "Env":"Prod"
  }
}

  resource "aws_key_pair" "bastion" {
    key_name = "octarine-bastion"
    public_key = file("${path.root}/modules/sshpub/oc7.pub")
  }

  resource "aws_instance" "bastion" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = element(var.subnets, 0)
    key_name = "octarine-bastion"
    vpc_security_group_ids = [aws_security_group.bastion_ssh.id]
    associate_public_ip_address = true

    tags = {
      "Env":"Prod"
    }
  }

  resource "aws_eip" "bastion" {
    instance = aws_instance.bastion.id
    vpc = true

    tags = {
      "Env":"Prod"
    }
}
