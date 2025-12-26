# Quiz 5 - Interact with Terraform Modules

## Explanation Guide

---

### Question 1

**Question:** You've included two different modules from the official Terraform registry in a new configuration file. When you run a terraform init where does Terraform OSS download and store the modules locally?

**Correct Answer:**

- In the `.terraform/modules` folder in the working directory

**Explanation:**
When you run `terraform init`, Terraform downloads all referenced modules and stores them locally in the `.terraform/modules` directory within your working directory. This hidden directory is created automatically and contains cached copies of all modules used in your configuration.

**Why the other options are incorrect:**

- In the `/tmp` directory – Terraform doesn't use the system temp directory for module storage
- In the same root directory – Modules aren't stored alongside your configuration files
- Terraform stores them in memory – Modules are persisted to disk, not kept only in memory

**Example / Command:**

```bash
# After running terraform init, you'll see:
terraform init

# Directory structure:
.
├── main.tf
├── .terraform/
│   └── modules/
│       ├── modules.json
│       ├── vpc/
│       └── security_group/
```

**Key Takeaway:**
Terraform stores downloaded modules in the `.terraform/modules` directory during initialization.

---

### Question 2

**Question:** A coworker provided you with Terraform configuration file that includes the code snippet below. Where will Terraform get the referenced module from?

```hcl
terraform {
  required_providers {
    kubernetes {
      source  = "hashicorp/kubernetes"
      version = "2.6.1"
    }
  }
}
```

**Correct Answer:**

- The official Terraform public module registry

**Explanation:**
The `source = "hashicorp/kubernetes"` syntax follows the format `namespace/provider-name`, which indicates this provider will be downloaded from the official Terraform Registry at `registry.terraform.io`. This is the default registry for providers when no explicit registry hostname is specified.

**Why the other options are incorrect:**

- From the configured VCS provider – This would require a different source format with a VCS URL
- From the official Kubernetes public GitHub repo – Terraform doesn't directly pull from GitHub unless explicitly configured
- From the hashicorp/kubernetes directory locally – This would require a local path source format

**Example / Command:**

```hcl
# Registry format (default)
source = "hashicorp/kubernetes"

# VCS format (alternative)
source = "github.com/hashicorp/terraform-provider-kubernetes"

# Local format (alternative)
source = "./local-providers/kubernetes"
```

**Key Takeaway:**
The `namespace/name` format in the source field pulls providers from the official Terraform Registry.

---

### Question 3

**Question:** A child module created a new subnet for some new workloads. What Terraform block type would allow you to pass the subnet ID back to the parent module?

**Correct Answer:**

- `output` block

**Explanation:**
Output blocks in child modules are used to expose values to the parent module. When a child module creates a resource like a subnet, it can use an output block to make the subnet ID available to the parent module, which can then reference it using `module.module_name.output_name`.

**Why the other options are incorrect:**

- `resource` block – Creates resources but doesn't expose values to parent modules
- `terraform` block – Used for Terraform settings and provider requirements, not data passing
- `data` block – Retrieves information about existing resources, doesn't pass values between modules

**Example / Command:**

```hcl
# In child module
resource "aws_subnet" "example" {
  vpc_id     = var.vpc_id
  cidr_block = "10.0.1.0/24"
}

output "subnet_id" {
  value = aws_subnet.example.id
}

# In parent module
module "networking" {
  source = "./modules/networking"
  vpc_id = aws_vpc.main.id
}

resource "aws_instance" "web" {
  subnet_id = module.networking.subnet_id
}
```

**Key Takeaway:**
Use output blocks in child modules to expose resource attributes to parent modules.

---

### Question 4

**Question:** You have a number of different variables in a parent module that calls multiple child modules. Can the child modules refer to any of the variables declared in the parent module?

**Correct Answer:**

- No, child modules can only refer to values that are passed to the child module

**Explanation:**
Child modules have their own variable scope and cannot directly access variables declared in the parent module. Values must be explicitly passed from parent to child through the module block's input variables. This encapsulation ensures modules are reusable and don't have hidden dependencies.

**Why the other options are incorrect:**

- No, child modules can never refer to any variables – This is too absolute; they can refer to values passed as inputs
- Yes, child modules can refer to any variable in a parent module – This would break module encapsulation and reusability

**Example / Command:**

```hcl
# Parent module
variable "environment" {
  default = "production"
}

variable "region" {
  default = "us-west-2"
}

module "vpc" {
  source = "./modules/vpc"

  # Must explicitly pass values
  environment = var.environment
  aws_region  = var.region
}

# Child module cannot access var.environment directly
# It must be passed as an input variable
```

**Key Takeaway:**
Child modules can only access values explicitly passed to them through input variables.

---

### Question 5

**Question:** True or False? When you are referencing a module, you must specify the version of the module in the calling module block.

**Correct Answer:**

- False

**Explanation:**
Specifying a version in the module block is not required, but it is highly recommended as a best practice. Without a version constraint, Terraform will use the latest available version, which could introduce breaking changes or unexpected behavior when the module is updated.

**Why this is important:**
While not mandatory, version pinning ensures reproducible deployments and prevents issues from automatic updates to newer module versions that might contain breaking changes.

**Example / Command:**

```hcl
# Without version (not recommended)
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
}

# With version (recommended)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"
}

# With exact version (most strict)
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
}
```

**Key Takeaway:**
Version specification is optional but strongly recommended for predictable and reproducible infrastructure.

---

## Summary

This quiz covers essential Terraform module concepts:

- **Module Storage**: Downloaded to `.terraform/modules` directory
- **Provider Sources**: Registry format `namespace/name` pulls from Terraform Registry
- **Data Flow**: Use `output` blocks to pass values from child to parent modules
- **Variable Scope**: Child modules only access explicitly passed input variables
- **Version Management**: Optional but highly recommended for stability

These concepts are fundamental for building modular, reusable, and maintainable Terraform configurations.
