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
    public  = "sg-02e42fea073555050"
    private = "sg-0761dbd2c071d5bad"
  }
}

variable "subnet_ids" {
  type = "map"

  default = {
    private_1a = "subnet-030ab1dd740571c37"
    private_1b = "subnet-00d3286c2c308f150"
    public_1a  = "subnet-051381725bdbaf070"
    public_1b  = "subnet-09aac952b11e29c65"
  }
}

variable "zero_cidr" {
  default = "0.0.0.0/0"
}

variable "my_ip" {
  default = "81.109.234.222/32"
}

variable "instance_type" {
  default = "t3.micro"
}
