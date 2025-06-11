resource "aws_launch_configuration" "terra-test" {
  image_id        = var.image_id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance-sg.id]
  user_data       = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  launch_configuration = aws_launch_configuration.terra-test.name
  vpc_zone_identifier  = data.aws_subnets.terra_vpc.ids
  target_group_arns    = [aws_lb_target_group.lb.arn]
  health_check_type    = "ELB"
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
  tag {
    key                 = "Name"
    value               = "${var.cluster_name}-asg"
    propagate_at_launch = true
  }

}
resource "aws_security_group" "instance-sg" {
  name   = "${var.cluster_name}-sg"
  vpc_id = aws_vpc.terra_vpc.id
}


data "aws_vpc" "terra_vpc" {
  default = false
  id      = aws_vpc.terra_vpc.id
  # depends_on = [ aws_vpc.terra_vpc ]
}

# data "aws_subnet" "pub" {
#   id = aws_subnet.terra_vpc_pub_01.id
# }

data "aws_subnets" "terra_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.terra_vpc.id]
  }
}

resource "aws_lb" "lb" {
  name               = "${var.cluster_name}-lb"
  load_balancer_type = "application"
  subnets            = [aws_subnet.terra_vpc_pub_01.id, aws_subnet.terra_vpc_pub_02.id]
  security_groups    = [aws_security_group.alb.id]
}

locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = local.http_port
  protocol          = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_security_group" "alb" {
  name   = "${var.cluster_name}-alb"
  vpc_id = aws_vpc.terra_vpc.id
}

resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.instance-sg.id
  from_port         = var.server_port
  to_port           = var.server_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}

resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.alb.id
  from_port         = local.http_port
  to_port           = local.http_port
  protocol          = local.tcp_protocol
  cidr_blocks       = local.all_ips
}

resource "aws_security_group_rule" "allow_http_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb.id
  from_port         = local.any_port
  to_port           = local.any_port
  protocol          = local.any_protocol
  cidr_blocks       = local.all_ips
}


resource "aws_lb_target_group" "lb" {
  name     = "${var.cluster_name}-lb"
  port     = var.server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.terra_vpc.id
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb.arn
  }
}

# data "terraform_remote_state" "db" {
#   backend = "s3"
#   config = {
#     bucket = var.db_remote_state_bucket
#     key = var.db_remote_state_key
#     region = "ap-southeast-1"
#   }
# }