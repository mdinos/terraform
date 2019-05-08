output "private_base_sg_id" {
  value = "${aws_security_group.private_subnets_sg.id}"
}

output "public_base_sg_id" {
  value = "${aws_security_group.public_subnets_sg.id}"
}