variable "region" {
  default = "eu-north-1"
}

variable "availability_zones" {
  default = ["eu-north-1a", "eu-north-1b"]
}

variable "vpc_id" {
  default = "vpc-4dc63724"
}

variable "vpc_name" {
  default = "marcus-vpc"
}

variable "vpc_cidr" {
  default = "172.31.0.0/16"
}

variable "subnet_cidrs" {
  type = "map"

  default = {
    private_1a = "172.31.1.0/24"
    private_1b = "172.31.2.0/24"
    public_1a  = "172.31.8.0/24"
    public_1b  = "172.31.9.0/24"
  }
}

variable "sg_ids" {
  type = "map"

  default = {
    public  = "sg-03fafefc26f4c16b9"
    private = "sg-02c2dfc1d5c4f05cd"
  }
}

variable "subnet_ids" {
  type = "map"

  default = {
    private_1a = "subnet-0f288397444f38ecb"
    private_1b = "subnet-0b9b2b04eda1eec52"
    public_1a  = "subnet-07b40d497845d5580"
    public_1b  = "subnet-0896c8095eea9e8f0"
  }
}

variable "zero_cidr" {
  default = "0.0.0.0/0"
}

variable "my_ip" {
  default = "81.109.234.222/32"
}

variable "10sc_ip" {
  default = "163.171.28.130/32"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "default_nacl_id" {
  default = "acl-1e926277"
}

variable "default_igw_id" {
  default = "igw-7358ac1a"
}

variable "route_tables" {
  type = "map"

  default = {
    "public"     = "rtb-0106c89539b7e1113"
    "private_1a" = "rtb-0f04c65eeefa5df33"
    "private_1b" = "rtb-06c5e16a37c54b147"
  }
}
