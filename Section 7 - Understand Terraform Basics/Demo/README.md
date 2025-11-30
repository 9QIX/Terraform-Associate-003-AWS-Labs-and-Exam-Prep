# Section 7 - Terraform Basics Demos (14-18)

This folder contains the consolidated demos from Section 7, covering lectures 14-18.

## Demos Included

### Demo 14 - Terraform Basics
- Basic Terraform workflow
- Simple random_string resource

### Demo 15 - HashiCorp Configuration Language (HCL)
- HCL syntax and structure
- AWS VPC, subnets, and networking resources

### Demo 16 - Terraform Plug-in Based Architecture
- Provider configuration
- Terraform block with required providers

### Demo 17 - Terraform Provider Block
- AWS provider configuration
- Region specification

### Demo 18 - Terraform Resource Block
- Complete AWS infrastructure setup
- VPC, subnets, route tables, NAT gateway
- EC2 instance with security groups
- S3 bucket
- TLS key generation

## Files

- `main.tf` - Main configuration with all resources
- `terraform.tf` - Terraform and provider version requirements
- `variables.tf` - Input variable definitions

## Usage

```bash
terraform init
terraform plan
terraform apply
terraform destroy
```
