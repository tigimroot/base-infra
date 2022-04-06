resource "aws_security_group" "bastion_ssh" {
  name = "mypage-bastion-ssh"
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

  tags = merge(tomap(
  {Name = "bastion_SG"}),
    var.mypage-tags,
)
}

  resource "aws_instance" "bastion" {
    ami = var.ami
    instance_type = var.instance_type
    subnet_id = element(var.subnets, 0)
    key_name = var.sshkey
    vpc_security_group_ids = [aws_security_group.bastion_ssh.id]
    associate_public_ip_address = true

    tags = merge(tomap({
      Name = "bastion_EC2"}
      ),
      var.mypage-tags,
  )
}

  resource "aws_eip" "bastion" {
    instance = aws_instance.bastion.id
    vpc = true

    tags = merge(tomap(
    {Name = "bastion_eip"}),
      var.mypage-tags,
  )
}
