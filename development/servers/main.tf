resource "aws_autoscaling_group" "marcus_asg" {
    name                = "marcus_asg"
    min_size            = "${var.ASG_min_size}"
    max_size            = "${var.ASG_max_size}"
    desired_capacity    = "${var.ASG_desired_size}"
    vpc_zone_identifier = [ "${aws_subnet.public_001.id}",
                            "${aws_subnet.private_001.id}",
                            "${aws_subnet.public_002.id}",
                            "${aws_subnet.private_002.id}"
                        ]

    launch_template = {
        id      = "${aws_launch_template.marcus_lt.id}"
        version = "$$Latest"
    }

}
resource "aws_default_security_group" "default_marcus_sg" {
    vpc_id = "${aws_vpc.marcus_vpc.id}"

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["${var.my_ip}"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.zero_ip}"]
    }
    tags = {
        Name = "default_marcus_sg"
    }
}
resource "aws_launch_template" "marcus_lt" {
    name            = "marcus_lt"
    instance_type   = "${var.instance_type}"
    image_id        = "${lookup(var.amis, var.region)}"
    key_name        = "terraform_ec2_key"

    network_interfaces {
        associate_public_ip_address = true
    }

    tags = {
        name = "marcus_lt"
    }
}

