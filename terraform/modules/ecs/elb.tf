
resource "aws_lb" "lifinance-lb" {
  name               = "lifinance-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http_traffic.id]
  subnets            = [for subnet in var.public_subnets : subnet]

  tags = {
    Name = "${var.env_code}-loadbalancer-my-sg"
  }
}

resource "aws_lb_target_group" "lifinance-tg" {
  name        = "lifinance-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 10
    timeout             = 60
    interval            = 300
    matcher             = "200,301,302"
  }
}


resource "aws_lb_listener" "lifinance-lb-listener" {
  load_balancer_arn = aws_lb.lifinance-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lifinance-tg.arn
  }
}
