resource "aws_ecs_service" "rs_api" {
  name            = "rs-api"
  cluster         = "${aws_ecs_cluster.rs-api.id}"
  launch_type     = "EC2"
  task_definition = "${aws_ecs_task_definition.rs_api.arn}"
  desired_count   = 1

  load_balancer {
    target_group_arn = "${aws_lb_target_group.rs_api_tg.arn}"
    container_name   = "rs-api"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "rs_api" {
  family                = "rs-api"
  container_definitions = "${file("rs-api-cd.json")}"
}

resource "aws_lb" "rs_api_lb" {
  name               = "rs-api-lb"
  load_balancer_type = "application"
  security_groups    = ["${var.sg_ids["private"]}"]
  subnets            = ["${var.subnet_ids["private_1a"]}", "${var.subnet_ids["private_1b"]}"]
}

resource "aws_lb_target_group" "rs_api_tg" {
  name     = "rs-api-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_lb_listener" "forward_to_rs_api" {
  load_balancer_arn = "${aws_lb.rs_api_lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.rs_api_tg.arn}"
  }
}

resource "aws_iam_role" "rs_api_role" {
  name = "rs_api_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "rs_api_role_policy" {
  name   = "${var.component}_role_policy"
  role   = "${aws_iam_role.rs_api_role.name}"
  policy = "${data.aws_iam_policy_document.rs_api_policy_document.json}"
}

data "aws_iam_policy_document" "rs_api_policy_document" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]

    resources = ["arn:aws:s3:::rs-tracker-lambda/*"]
  }
}
