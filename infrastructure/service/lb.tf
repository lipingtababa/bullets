resource "aws_lb" "lb" {
  name               = "${var.app_name}-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = local.subnet_ids
  security_groups    = [aws_security_group.alb.id]

  enable_deletion_protection = false

  tags = {
    Environment = "${var.stage}"
  }
}

resource "aws_lb_listener" "thelistener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "8080"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "${var.app_name}"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  target_type = "ip"

  health_check {
    enabled             = true
    interval            = 30
    path                = "/ping"
    port                = 8081
    timeout             = 3
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.app_name}-alb"
  description = "ALB security group"
  vpc_id      = local.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
