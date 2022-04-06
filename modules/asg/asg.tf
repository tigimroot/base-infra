resource "aws_security_group" "kw_asg_sg" {
  name = "OC-7_asg_secirity_group"
  vpc_id = var.vpc_id

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [var.alb_sg]
  }

  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [var.alb_sg]
  }

  ingress{
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = merge(tomap({
    Name = "kw_asg_sg"}
    ),
    var.mypage-tags,
)
}

resource "aws_launch_configuration" "mypage" {
name_prefix   = "OC-7-"
image_id               = var.ami
instance_type          = var.instance_type
associate_public_ip_address = true
security_groups = [aws_security_group.kw_asg_sg.id]
key_name = var.sshkey
user_data = filebase64("${path.module}/userdata.sh")

lifecycle {
  create_before_destroy = true
   }
}

resource "aws_autoscaling_group" "mypage" {
  #availability_zones = var.availability_zones
  vpc_zone_identifier = var.subnets
  max_size = var.asg_max_size
  min_size = var.asg_min_size
  desired_capacity =  var.asg_min_size
  target_group_arns = [var.alb_tg_arn]
  launch_configuration = aws_launch_configuration.mypage.name
  health_check_type = "ELB"

  lifecycle {
    create_before_destroy = true
  }

}
