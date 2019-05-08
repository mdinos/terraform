variable "component" {
  default = "rs_api"
}

variable "ecs_role" {
  default = "AWSServiceRoleForECS"
}

variable "ecs_instance_ami" {
  default = "ami-036cf93383aba5279"
}
