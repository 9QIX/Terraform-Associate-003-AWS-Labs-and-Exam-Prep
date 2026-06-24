variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  type    = string
  default = "demo_vpc"
}

variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "variables_sub_az" {
  type    = string
  default = "us-east-1a"
}

variable "server_name" {
  type    = string
  default = "demo-server"
}
