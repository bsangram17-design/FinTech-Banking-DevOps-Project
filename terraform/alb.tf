resource "aws_lb" "alb" {
  name               = "fintech-alb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.public_1.id, aws_subnet.public_2.id]
  security_groups    = [aws_security_group.alb_sg.id]
}

resource "aws_lb_target_group" "blue" {
  name     = "fintech-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/health"
  }
}

resource "aws_lb_target_group" "green" {
  name     = "fintech-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/health"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_lb_target_group_attachment" "blue_attach" {
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = aws_instance.app.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "green_attach" {
  target_group_arn = aws_lb_target_group.green.arn
  target_id        = aws_instance.app.id
  port             = 80
}
