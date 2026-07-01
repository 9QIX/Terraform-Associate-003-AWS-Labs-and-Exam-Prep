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
    "public_subnet_3" = 3
  }
}

variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
    "private_subnet_3" = 3
  }
}

variable "variables_sub_cidr" {
  type    = string
  default = "10.0.200.0/24"
}

variable "variables_sub_auto_ip" {
  type    = bool
  default = false
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


variable "phone_number" {
  type      = string
  sensitive = true
  default   = "867-5309"
}

variable "us-east-1-azs" {
    type = list(string)
    default = [
        "us-east-1a",
        "us-east-1b",
        "us-east-1c",
        "us-east-1d",
        "us-east-1e"
    ]
}

variable "ip" {
  type = map(string)
  default = {
    prod = "10.0.150.0/24"
    dev  = "10.0.250.0/24"
  }
}

variable "env" {
  type = map(any)
  default = {
    prod = {
      ip = "10.0.150.0/24"
      az = "us-east-1a"
    }
    dev  = {
      ip = "10.0.250.0/24"
      az = "us-east-1e"
    }
  }
}