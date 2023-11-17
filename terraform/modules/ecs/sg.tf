resource "aws_security_group" "http_traffic" {
  name        = "allow_http"
  description = "Allow http traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.env_code}-my-sg"
  }
}

resource "aws_security_group" "private" {
  name        = "${var.env_code}-private"
  description = "Allow Http from load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Http from load balancer"
    from_port       = 4005
    to_port         = 4005
    protocol        = "tcp"
    security_groups = [aws_security_group.http_traffic.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-my-sg"
  }
}
