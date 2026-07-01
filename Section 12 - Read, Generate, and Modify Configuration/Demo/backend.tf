terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

# terraform {
#   backend "s3" {
#     bucket = "for-the-clawt"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#
#     endpoints = {
#       s3 = "http://192.168.1.144:4566"
#     }
#
#     skip_credentials_validation = true
#     skip_metadata_api_check     = true
#     skip_region_validation      = true
#     skip_requesting_account_id  = true
#     use_path_style              = true
#
#     access_key = "test"
#     secret_key = "test"
#   }
# }
