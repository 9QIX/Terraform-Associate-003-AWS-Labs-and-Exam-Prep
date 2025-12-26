variable "ami" {}

variable "size" {
  default = "t3.micro"
}

variable "subnet_id" {}

variable "user" {}

variable "security_groups" {
  type = list(any)
}

variable "key_name" {}

variable "private_key" {}