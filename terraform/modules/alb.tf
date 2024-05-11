#####################################################
## ALB
#####################################################
resource "aws_lb" "main" {
  name = "${var.app_name}-${var.env_short}-alb"
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb.id]
  subnets = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id
  ]
}

#####################################################
## Listener
#####################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.subdomain.arn
  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Service Unavailable"
      status_code  = "503"
    }
  }
  depends_on = [
    aws_acm_certificate_validation.subdomain
  ]
}

resource "aws_lb_listener_rule" "lambda" {
  listener_arn = aws_lb_listener.https.arn
  priority = 4
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.lambda.arn
  }
  condition {
    host_header {
      values = [var.subdomain_name]
    }
  }
  condition {
    path_pattern {
      values = ["/api/*"]
    }
  }
}



#####################################################
## Target Group
#####################################################

resource "aws_lb_target_group" "lambda" {
  name        = "${var.app_name}-${var.env_short}-lambda-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lambda_attachment" {
  target_group_arn = aws_lb_target_group.lambda.arn
  target_id        = aws_lambda_function.main.arn
}
