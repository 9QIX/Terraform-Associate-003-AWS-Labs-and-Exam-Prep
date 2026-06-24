provider "aws" {
  region                      = "us-east-1"
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://192.168.1.145:4566"
    s3  = "http://192.168.1.145:4566"
    iam = "http://192.168.1.145:4566"
    sts = "http://192.168.1.145:4566"
  }

  default_tags {
    tags = {
      "Provisioned" = "Terraform"
      "Terraform"   = "true"
    }
  }
}
