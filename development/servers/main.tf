resource "aws_autoscaling_group" "marcus_nginx_asg" {
  name               = "marcus_nginx_asg"
  min_size           = "0"
  max_size           = "2"
  desired_capacity   = "1"
  target_group_arns  = ["${aws_lb_target_group.marcus_nginx_tg.arn}"]
  availability_zones = "${var.availability_zones}"

  vpc_zone_identifier = [
    "${var.subnet_ids["public_1a"]}",
    "${var.subnet_ids["public_1b"]}",
  ]

  launch_template = {
    id      = "${aws_launch_template.marcus_nginx_lt.id}"
    version = "$$Latest"
  }
}

resource "aws_lb" "marcus_nginx_lb" {
  name               = "marcus-nginx-lb"
  load_balancer_type = "application"
  security_groups    = ["${var.sg_ids["public"]}"]
  subnets            = ["${var.subnet_ids["public_1a"]}", "${var.subnet_ids["public_1b"]}"]

  access_logs {
    bucket  = "${aws_s3_bucket.marcus-nginx-access-s3.id}"
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
  name                   = "marcus_nginx_lt"
  instance_type          = "${var.instance_type}"
  image_id               = "${data.aws_ami.marcus-nginx-ami.id}"
  vpc_security_group_ids = ["${var.sg_ids["public"]}"]
  key_name               = "marcus-macos"
  
  network_interfaces {
        associate_public_ip_address = true
    }

  tags = {
    name = "marcus_nginx_lt"
  }
}

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "marcus-nginx-access-s3" {
  bucket = "marcus-nginx-access-s3"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "ngnix_access"
    Environment = "development"
  }

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::marcus-nginx-access-s3/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}
