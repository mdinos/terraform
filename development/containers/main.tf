resource "aws_ecs_service" "rs_api" {
  name            = "rs-api"
  launch_type     = "FARGATE"
  task_definition = "${aws_ecs_task_definition.rs_api.arn}"
  desired_count   = 1
  iam_role        = "${aws_iam_role.rs_api_role.arn}"

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

resource "aws_lb_target_group" "rs_api_tg" {
  name     = "rs-api-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

resource "aws_iam_role" "rs_api_role" {
  name = "rs_api_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Principal": ["arn:aws:s3:::rs-tracker-lambda/*"]
    }
  ]
}
EOF

  tags = {
    Name = "rs_api_role"
  }
}
