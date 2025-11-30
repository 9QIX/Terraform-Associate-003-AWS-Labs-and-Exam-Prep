terraform {
  required_version = ">=0.15.0"
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">=3.0"
    }
    http = {
        source = "hashicorp/http"
        version = ">=2.0"
    }
    random = {
        source = "hashicorp/random"
        version = "3.1.2"
    }
    local = {
        source = "hashicorp/local"
        version = ">=2.0"
    }
  }
}