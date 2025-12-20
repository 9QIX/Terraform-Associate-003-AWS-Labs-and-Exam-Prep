# Quiz 4 - Use Terraform Outside of Core Workflow

## Explanation Guide

---

### Question 1

**Question:** Your colleague provided you with a Terraform configuration file and you're having trouble reading it because parameters and blocks are not properly aligned. What command can you run to quickly update the file configuration file to make it easier to consume?

**Correct Answer:**

- `terraform fmt`

**Explanation:**
The `terraform fmt` command automatically formats Terraform configuration files to follow the canonical style conventions. It adjusts indentation, alignment, and spacing to make the code more readable and consistent across your team.

**Why the other options are incorrect:**

- `terraform init` – Initializes a Terraform working directory by downloading providers and modules, not for formatting
- `terraform state` – Used for advanced state management operations, not code formatting
- `terraform workspace` – Manages multiple named workspaces for deploying the same configuration to different environments

**Example / Command:**

```bash
terraform fmt
```

Or to format files recursively in subdirectories:

```bash
terraform fmt -recursive
```

**Key Takeaway:**
Use `terraform fmt` to automatically format and align Terraform configuration files for better readability.

---

### Question 2

**Question:** You have a configuration file that you've deployed to one AWS region already but you want to deploy the same configuration file to a second AWS region without making changes to the configuration file. What feature of Terraform can you use to accomplish this?

**Correct Answer:**

- `terraform workspace`

**Explanation:**
Terraform workspaces allow you to manage multiple instances of the same infrastructure configuration. Each workspace maintains its own separate state file, enabling you to deploy identical configurations to different regions or environments without modifying the code. You can use variables or conditional logic based on the workspace name to target different regions.

**Why the other options are incorrect:**

- `terraform import` – Brings existing infrastructure under Terraform management, doesn't deploy to new regions
- `terraform taint` – Marks a resource for recreation on the next apply, not for multi-region deployment
- `terraform plan` – Shows what changes will be made, doesn't manage multiple deployments

**Example / Command:**

```bash
# Create and switch to a new workspace for the second region
terraform workspace new us-west-2

# List all workspaces
terraform workspace list

# Switch between workspaces
terraform workspace select us-east-1
```

In your configuration, you can reference the workspace:

```hcl
provider "aws" {
  region = terraform.workspace == "us-east-1" ? "us-east-1" : "us-west-2"
}
```

**Key Takeaway:**
Use workspaces to deploy the same configuration to multiple environments or regions with separate state files.

---

### Question 3

**Question:** After deploying a new virtual machine using Terraform, you find that the local script didn't run properly. However, Terraform reports the virtual machine was successfully created. How can you force Terraform to replace the virtual machine without impacting the rest of the managed infrastructure?

**Correct Answer:**

- Use `terraform taint` to tag the resource for replacement

**Explanation:**
The `terraform taint` command marks a specific resource as degraded or damaged, forcing Terraform to destroy and recreate it on the next `terraform apply`. This allows you to replace a single problematic resource without affecting other managed infrastructure.

**Why the other options are incorrect:**

- `terraform destroy` and then `terraform import` – Destroys all resources, not just the problematic VM
- `terraform debug` – Not a valid Terraform command
- Update the VM resource and run `terraform init` – `init` doesn't apply changes; you'd need `apply`, and simply updating the resource may not force replacement

**Example / Command:**

```bash
# Taint a specific resource
terraform taint aws_instance.web_server

# Run apply to replace the tainted resource
terraform apply
```

**Note:** In Terraform 0.15.2+, `terraform taint` is deprecated in favor of:

```bash
terraform apply -replace="aws_instance.web_server"
```

**Key Takeaway:**
Use `terraform taint` (or `-replace` flag) to force recreation of a single resource without affecting other infrastructure.

---

### Question 4

**Question:** You are managing multiple resources using Terraform running in AWS. You want to destroy all the resources except for a single web server. How can you accomplish this?

**Correct Answer:**

- Run a `terraform state rm` to remove it from state and then destroy the remaining resources by running `terraform destroy`

**Explanation:**
The `terraform state rm` command removes a resource from the Terraform state file without destroying the actual infrastructure. Once removed from state, Terraform no longer manages that resource. You can then safely run `terraform destroy` to remove all other resources while the web server remains untouched in AWS.

**Why the other options are incorrect:**

- Change to a different workspace and run `terraform destroy` – This would destroy resources in a different workspace, not selectively destroy in the current one
- Run `terraform import` against the web server then `terraform destroy` – Import adds resources to state; destroy would still target all resources including the web server
- Delete the web server resource block and run `terraform apply` – This would destroy the web server, which is the opposite of what you want

**Example / Command:**

```bash
# Remove the web server from state
terraform state rm aws_instance.web_server

# Destroy all remaining managed resources
terraform destroy
```

**Important Note:** The web server will continue running in AWS but will no longer be managed by Terraform. If you want to manage it again later, you'll need to import it back into state.

**Key Takeaway:**
Use `terraform state rm` to remove a resource from Terraform management before destroying other resources.

---

### Question 5

**Question:** You are having trouble with executing Terraform and want to enable the most verbose logs. What log level should you set for the TF_LOG environment variable?

**Correct Answer:**

- `TRACE`

**Explanation:**
`TRACE` is the most verbose logging level in Terraform. It provides the most detailed output, including all internal operations, API calls, and debugging information. This is extremely useful for troubleshooting complex issues or understanding exactly what Terraform is doing during execution.

**Why the other options are incorrect:**

- `ERROR` – Only shows error messages, the least verbose level
- `INFO` – Shows informational messages but less detail than DEBUG or TRACE
- `DEBUG` – Provides detailed debugging information but less verbose than TRACE

**Log Levels (from least to most verbose):**

1. ERROR
2. WARN
3. INFO
4. DEBUG
5. TRACE

**Example / Command:**

```bash
# Linux/macOS
export TF_LOG=TRACE
terraform apply

# Windows PowerShell
$env:TF_LOG="TRACE"
terraform apply

# Windows Command Prompt
set TF_LOG=TRACE
terraform apply
```

You can also direct logs to a file:

```bash
export TF_LOG=TRACE
export TF_LOG_PATH=./terraform.log
terraform apply
```

**Key Takeaway:**
Set `TF_LOG=TRACE` for the most verbose logging output when troubleshooting Terraform issues.

---

## Summary

This quiz covers advanced Terraform workflow commands:

- **`terraform fmt`** – Format configuration files
- **`terraform workspace`** – Manage multiple deployments with separate state
- **`terraform taint`** – Force resource replacement
- **`terraform state rm`** – Remove resources from state management
- **`TF_LOG=TRACE`** – Enable maximum verbosity for debugging

These commands are essential for day-to-day Terraform operations beyond the basic `init`, `plan`, `apply`, and `destroy` workflow.
