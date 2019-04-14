provider "aws" {
  version = "~> 2.0.0"
  region  = "eu-north-1"
}

terraform {
  required_version = " ~> 0.11.13"
}

provider "template" {
  version = "2.0.0"
}

provider "random" {
  version = "~> 2.0"
}
