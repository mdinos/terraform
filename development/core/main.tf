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

resource "aws_default_network_acl" "marcus_acl" {
  default_network_acl_id = "${var.default_nacl_id}"
  subnet_ids             = ["${var.subnet_ids["public_1a"]}", "${var.subnet_ids["public_1b"]}", "${var.subnet_ids["private_1a"]}", "${var.subnet_ids["private_1b"]}"]

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
    rule_no    = 220
    action     = "allow"
    cidr_block = "${var.10sc_ip}"
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

  egress {
    protocol   = "-1"
    rule_no    = 310
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = "tcp"
    rule_no    = 320
    action     = "allow"
    cidr_block = "${var.10sc_ip}"
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
    cidr_blocks = ["${var.my_ip}", "${var.10sc_ip}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.subnet_cidrs["public_1b"]}", "${var.subnet_cidrs["private_1a"]}", "${var.subnet_cidrs["private_1b"]}", "${var.subnet_cidrs["public_1a"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.zero_cidr}"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}", "${var.10sc_ip}"]
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
    cidr_blocks = ["${var.my_ip}", "${var.10sc_ip}"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.zero_cidr}", "${var.subnet_cidrs["public_1a"]}","${var.subnet_cidrs["public_1b"]}", "${var.subnet_cidrs["private_1a"]}", "${var.subnet_cidrs["private_1b"]}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.zero_cidr}"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}", "${var.10sc_ip}"]
  }
}

/*resource "aws_eip" "nat_gw_eip_1a" {}

resource "aws_eip" "nat_gw_eip_1b" {}

resource "aws_nat_gateway" "public_nat_gw_1a" {
  allocation_id = "${aws_eip.nat_gw_eip_1a.id}"
  subnet_id     = "${var.subnet_ids["public_1a"]}"

  tags = {
    Name = "public_subnet_nat_gw_1a"
  }
}

resource "aws_nat_gateway" "public_nat_gw_1b" {
  allocation_id = "${aws_eip.nat_gw_eip_1b.id}"
  subnet_id     = "${var.subnet_ids["public_1b"]}"

  tags = {
    Name = "public_subnet_nat_gw_1b"
  }
}
*/