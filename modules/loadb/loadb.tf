
resource "aws_security_group" "kw_lb_sg" {
  name = "kw_lb_secirity_group"
  vpc_id = var.vpc_id

  ingress{
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress{
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(tomap(
  {Name = "kw_lb_secirity_group"}),
    var.mypage-tags
)
}

resource "aws_lb" "alb" {
  subnets             = var.subnets
  security_groups     = [aws_security_group.kw_lb_sg.id]
  internal            = false
  load_balancer_type          = "application"
  ip_address_type             = "ipv4"

  tags = merge(tomap(
  {Name = "mypage_alb"}),
    var.mypage-tags
)
}

resource "aws_lb_target_group" "alb_tg" {
  port                 = "80"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-499"
    interval            = 20
    timeout             = 15
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  lifecycle {
   create_before_destroy = true
 }

 tags = merge(tomap(
 {Name = "mypage_alb_tg"}),
   var.mypage-tags
)
}

resource "aws_lb_listener" "http" {
  load_balancer_arn   = aws_lb.alb.arn
  port                = "80"
  protocol            = "HTTP"


  default_action {
    type = "redirect"

  redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(tomap(
  {Name = "mypage_http_listener"}),
    var.mypage-tags
)
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2020-10"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
    }

    tags = merge(tomap(
    {Name = "mypage_https_listener"}),
      var.mypage-tags
  )


depends_on = [aws_lb_target_group.alb_tg]
}
