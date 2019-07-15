resource "aws_autoscaling_group" "marcus_nginx_asg" {
  name               = "[PUBLIC] NGINX_ASG"
  min_size           = "1"
  max_size           = "2"
  desired_capacity   = "1"
  target_group_arns  = ["${aws_lb_target_group.marcus_nginx_tg.arn}"]
  availability_zones = "${var.availability_zones}"
  default_cooldown   = 150

  vpc_zone_identifier = [
    "${var.subnet_ids["public_1a"]}",
    "${var.subnet_ids["public_1b"]}",
  ]

  launch_template = {
    id      = "${aws_launch_template.marcus_nginx_lt.id}"
    version = "$$Latest"
  }
}

data "aws_s3_bucket" "marcus_nginx_access_s3" {
  bucket = "marcus-nginx-access-s3"
}

resource "aws_lb" "marcus_nginx_lb" {
  name               = "marcus-nginx-lb"
  load_balancer_type = "application"
  security_groups    = ["${var.sg_ids["public"]}"]
  subnets            = ["${var.subnet_ids["public_1a"]}", "${var.subnet_ids["public_1b"]}"]

  access_logs {
    bucket  = "${data.aws_s3_bucket.marcus_nginx_access_s3.id}"
    enabled = true
  }
}

resource "aws_lb_listener" "forward_to_nginx" {
  load_balancer_arn = "${aws_lb.marcus_nginx_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.marcus_nginx_tg.arn}"
  }
}

data "aws_ami" "marcus-nginx-ami" {
  most_recent = true
  name_regex  = "marcus-nginx-ami*"
  owners      = ["474307705618"]
}

resource "aws_lb_target_group" "marcus_nginx_tg" {
  name     = "marcus-nginx-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_launch_template" "marcus_nginx_lt" {
  name          = "marcus_nginx_lt"
  instance_type = "${var.instance_type}"
  image_id      = "${data.aws_ami.marcus-nginx-ami.id}"
  key_name      = "marcus"

  iam_instance_profile {
    arn = "arn:aws:iam::474307705618:instance-profile/EC2ReadFromS3"
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = ["${var.sg_ids["public"]}"]
    delete_on_termination       = true
  }

  tags = {
    key                 = "Name"
    value               = "marcus-nginx"
    propagate_at_launch = true
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" = "[PUBLIC] Nginx"
    }
  }
}
