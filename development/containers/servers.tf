resource "aws_launch_template" "rs_ecs_cluster_lt" {
  name          = "rs_ecs_cluster_lc"
  image_id      = "${var.ecs_instance_ami}"
  instance_type = "t3.micro"
  key_name      = "marcus"

  iam_instance_profile {
    arn = "arn:aws:iam::474307705618:instance-profile/EC2ReadFromS3"
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = ["${var.sg_ids["private"]}"]
  }

  user_data = "${base64encode("export ECS_CLUSTER=rs-api && sudo yum install ecs-init && sudo start ecs")}"
}

resource "aws_autoscaling_group" "rs_ecs_cluster_asg" {
  name               = "rs_ecs_cluster_asg"
  min_size           = "0"
  max_size           = "2"
  desired_capacity   = "1"
  availability_zones = "${var.availability_zones}"

  vpc_zone_identifier = [
    "${var.subnet_ids["private_1a"]}",
    "${var.subnet_ids["private_1b"]}",
  ]

  launch_template = {
    id      = "${aws_launch_template.rs_ecs_cluster_lt.id}"
    version = "$$Latest"
  }

  tag {
    key                 = "Name"
    value               = "rs_api_ecs_cluster"
    propagate_at_launch = true
  }
  tag {
    key                 = "Zone"
    value               = "Private"
    propagate_at_launch = true
  }
}
