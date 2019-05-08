data "aws_vpc" "marcus_vpc" {
  id         = "${var.vpc_id}"
  cidr_block = "${var.vpc_cidr}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id            = "${data.aws_vpc.marcus_vpc.id}"
  cidr_block        = "${var.subnet_cidrs["private_1a"]}"
  availability_zone = "${var.availability_zones[0]}"

  tags = {
    Name = "private_1a"
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id            = "${data.aws_vpc.marcus_vpc.id}"
  cidr_block        = "${var.subnet_cidrs["public_1a"]}"
  availability_zone = "${var.availability_zones[0]}"

  tags = {
    Name = "public_1a"
  }
}

resource "aws_subnet" "private_1b" {
  vpc_id            = "${data.aws_vpc.marcus_vpc.id}"
  cidr_block        = "${var.subnet_cidrs["private_1b"]}"
  availability_zone = "${var.availability_zones[1]}"

  tags = {
    Name = "private_1b"
  }
}

resource "aws_subnet" "public_1b" {
  vpc_id            = "${data.aws_vpc.marcus_vpc.id}"
  cidr_block        = "${var.subnet_cidrs["public_1b"]}"
  availability_zone = "${var.availability_zones[1]}"

  tags = {
    Name = "public_1b"
  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = "${data.aws_vpc.marcus_vpc.id}"
  route_table_id = "${aws_route_table.marcus_route_t.id}"
}

resource "aws_default_network_acl" "marcus_acl" {
  default_network_acl_id = "${var.default_nacl_id}"

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = "${var.my_ip}"
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 210
    action     = "allow"
    cidr_block = "${var.zero_cidr}"
    from_port  = 80
    to_port    = 80
  }

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = "${var.my_ip}"
    from_port  = 22
    to_port    = 22
  }

  tags = {
    Name = "marcus_acl"
  }
}

resource "aws_security_group" "private_subnets_sg" {
  name        = "private_subnets_sg"
  description = "Base SG for private subnets"
  vpc_id      = "${data.aws_vpc.marcus_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidrs["public_1a"]}", "${var.subnet_cidrs["public_1b"]}", "${var.subnet_cidrs["private_1a"]}", "${var.subnet_cidrs["private_1b"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.subnet_cidrs["public_1a"]}", "${var.subnet_cidrs["public_1b"]}", "${var.subnet_cidrs["private_1a"]}", "${var.subnet_cidrs["private_1b"]}"]
  }
}

resource "aws_security_group" "public_subnets_sg" {
  name        = "public_subnets_sg"
  description = "Base SG for public subnets"
  vpc_id      = "${data.aws_vpc.marcus_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.zero_cidr}", "${var.subnet_cidrs["public_1a"]}", "${var.subnet_cidrs["public_1b"]}", "${var.subnet_cidrs["private_1a"]}", "${var.subnet_cidrs["private_1b"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.zero_cidr}"]
  }
}

resource "aws_route_table" "marcus_route_t" {
  vpc_id = "${data.aws_vpc.marcus_vpc.id}"

  route {
    cidr_block = "${var.zero_cidr}"
    gateway_id = "${var.default_igw_id}"
  }

  tags = {
    Name = "marcus_route_t"
  }
}