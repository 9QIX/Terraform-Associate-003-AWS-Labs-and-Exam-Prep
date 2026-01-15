# Quiz - Terraform Core Workflow

## Explanation Guide

---

### Question 1

**Question:** True or False? Running a terraform apply will fail if you do not run a terraform plan first.

**Correct Answer:**

- False

**Explanation:**
Running `terraform plan` before `terraform apply` is not required. The `terraform apply` command automatically performs a plan operation internally before prompting you to approve the changes. However, running `terraform plan` separately is a best practice to review changes before applying them.

**Why this matters:**
While `terraform plan` is optional, it's highly recommended to run it first to preview changes and catch potential issues before modifying infrastructure.

**Example / Command:**

```bash
# This works without running plan first
terraform apply

# Best practice: review changes first
terraform plan
terraform apply
```

**Key Takeaway:**
`terraform plan` is not required before `terraform apply`, but it's a recommended best practice.

---

### Question 2

**Question:** After hours of development, you've created a new Terraform configuration from scratch and now you want to test it. Before you can provision the resources, what is the first command that you should run?

**Correct Answer:**

- `terraform init`

**Explanation:**
`terraform init` is always the first command to run in a new Terraform configuration. It initializes the working directory by downloading required provider plugins, setting up the backend, and retrieving any referenced modules. Without initialization, Terraform cannot execute any other commands.

**Why the other options are incorrect:**

- `terraform apply` – Cannot run without initialization; requires providers and modules to be downloaded first
- `terraform import` – Used to bring existing infrastructure under Terraform management, not for new configurations
- `terraform validate` – Validates syntax but requires initialization to be completed first

**Example / Command:**

```bash
# First command for any new Terraform project
terraform init

# Then you can proceed with other commands
terraform validate
terraform plan
terraform apply
```

**Key Takeaway:**
Always run `terraform init` first to initialize the working directory and download required dependencies.

---

### Question 3

**Question:** What actions does a terraform init perform for you?

**Correct Answer:**

- Downloads plugins and retrieves the source code for referenced modules

**Explanation:**
`terraform init` performs several initialization tasks: it downloads provider plugins specified in the configuration, retrieves source code for any modules referenced, and sets up the backend for state storage. This prepares the working directory for all subsequent Terraform operations.

**Why the other options are incorrect:**

- Ensures any `.tf` file is syntactically valid and internally consistent – This is what `terraform validate` does
- Ensures that all terraform files match canonical formatting – This is what `terraform fmt` does
- Compares current configuration to prior state and notes differences – This is what `terraform plan` does

**Example / Command:**

```bash
terraform init

# Output shows:
# - Initializing provider plugins
# - Initializing modules
# - Initializing the backend
```

**Key Takeaway:**
`terraform init` downloads providers and modules, preparing the working directory for Terraform operations.

---

### Question 4

**Question:** Which of the following is a task that a terraform apply cannot perform?

**Correct Answer:**

- Import infrastructure

**Explanation:**
`terraform apply` is used to create, update, or destroy infrastructure based on your configuration, but it cannot import existing infrastructure into Terraform state. Importing requires the separate `terraform import` command to bring externally created resources under Terraform management.

**Why the other options are incorrect:**

- Provision new infrastructure – This is a primary function of `terraform apply`
- Destroy infrastructure previously deployed with Terraform – `terraform apply` can destroy resources when they're removed from configuration
- Update existing infrastructure with new configurations – This is a core function of `terraform apply`

**Example / Command:**

```bash
# terraform apply can do these:
terraform apply                    # Create/update resources
terraform apply -destroy           # Destroy resources

# But NOT this (requires separate command):
terraform import aws_instance.web i-1234567890abcdef0
```

**Key Takeaway:**
`terraform apply` creates, updates, and destroys infrastructure but cannot import existing resources.

---

### Question 5

**Question:** You have infrastructure deployed with Terraform. A developer recently submitted a support ticket to update a security group to permit a new port. To satisfy the ticket, you update the Terraform configuration to reflect the changes and run a terraform plan. However, a co-worker has since logged into the console and manually updated the security group. What will happen when you run a terraform apply?

**Correct Answer:**

- Nothing will happen. Terraform will validate the infrastructure matches the desired state.

**Explanation:**
When you run `terraform apply`, Terraform first refreshes the state by querying the actual infrastructure. If it detects that the real-world infrastructure already matches your desired configuration (because your co-worker manually made the same change), Terraform will recognize no changes are needed and will not modify anything.

**Why the other options are incorrect:**

- The terraform apply command will require you to re-run terraform plan first – `terraform apply` doesn't require re-running plan
- The security group will be changed back to the original configuration – Terraform only reverts to configuration if the real-world state differs from desired state
- Terraform will detect the drift and return an error – Drift detection doesn't cause errors; Terraform simply reconciles to the desired state

**Example / Command:**

```bash
# Scenario:
terraform plan
# Shows: Will add port 443 to security group

# Co-worker manually adds port 443 via console

terraform apply
# Output: "No changes. Your infrastructure matches the configuration."
```

**Key Takeaway:**
`terraform apply` refreshes state and only makes changes if real-world infrastructure differs from desired configuration.

---

## Summary

This quiz covers the Terraform core workflow commands:

- **`terraform init`** – First command to run; downloads providers and modules
- **`terraform plan`** – Optional but recommended; previews changes before applying
- **`terraform apply`** – Creates, updates, or destroys infrastructure based on configuration
- **`terraform import`** – Separate command for bringing existing infrastructure under management
- **State Refresh** – `terraform apply` automatically refreshes state to detect drift

Understanding this workflow is essential for the Terraform Associate 003 certification and day-to-day Terraform operations.
