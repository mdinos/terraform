resource "aws_instance" "bastion" {
  ami                    = "${var.al2_ami_id}"
  instance_type          = "t3.nano"
  availability_zone      = "${var.availability_zones[0]}"
  key_name               = "marcus"
  vpc_security_group_ids = ["${var.sg_ids["public"]}"]
  subnet_id              = "${var.subnet_ids["public_1a"]}"
}

resource "aws_eip" "bastion_eip" {
  vpc = true
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.bastion.id}"
  allocation_id = "${aws_eip.bastion_eip.id}"
}
