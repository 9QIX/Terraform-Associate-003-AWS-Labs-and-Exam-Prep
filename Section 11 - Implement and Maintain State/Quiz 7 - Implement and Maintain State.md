# Quiz 7 - Implement and Maintain State

## Explanation Guide

---

### Question 1

**Question:** By default, where does Terraform CLI store its state?

**Correct Answer:**

- In the `terraform.tfstate` file on the local backend

**Explanation:**
By default, Terraform stores state locally in a file named `terraform.tfstate` in the root of the working directory. This is referred to as the "local backend." While this default behavior works for individual development, it can be changed to a remote backend for team collaboration and improved security.

**Why the other options are incorrect:**

- In the default workspace in Terraform Cloud – Terraform Cloud is a remote backend that must be explicitly configured; it's not the default
- In the `.terraform` directory – This directory stores providers and modules downloaded during `terraform init`, not the state file
- In a temp directory on the local machine – Terraform never uses temporary directories for state storage

**Example / Command:**

```bash
# After terraform apply, you'll see:
.
├── main.tf
├── terraform.tfstate        # <-- State stored here by default
└── terraform.tfstate.backup
```

**Key Takeaway:**
Terraform stores state locally in a `terraform.tfstate` file by default, but this can be changed to a remote backend.

---

### Question 2

**Question:** Both you and a colleague are responsible for maintaining resources that host multiple applications using Terraform CLI. What feature of Terraform helps ensure only a single person can update or make changes to the resources Terraform is managing?

**Correct Answer:**

- State locking

**Explanation:**
State locking prevents concurrent operations against the same state file. When an operation that could write state is initiated, Terraform locks the state file so no other user or process can make changes simultaneously. This prevents conflicts, corruption, and race conditions in team environments.

**Why the other options are incorrect:**

- Local backend – A local backend stores state but doesn't inherently protect against concurrent writes from multiple users
- Version control – Version control tracks code changes but doesn't prevent simultaneous Terraform operations
- Provisioners – Provisioners execute scripts on resources after creation; they have nothing to do with state protection

**Example / Command:**

```bash
# When state is locked, other operations will see:
Error: Error acquiring the state lock

# You can force unlock if needed (use with caution):
terraform force-unlock LOCK_ID
```

**Key Takeaway:**
State locking prevents concurrent writes to the state file, ensuring only one person can modify infrastructure at a time.

---

### Question 3

**Question:** Where is the most secure place to store credentials when using a remote backend?

**Correct Answer:**

- Environment variables defined outside of Terraform

**Explanation:**
Storing credentials in environment variables outside of Terraform is the most secure approach because they are never written to configuration files, never committed to version control, and never stored in state. This follows the principle of keeping secrets out of code entirely.

**Why the other options are incorrect:**

- In the backend configuration block – Credentials in configuration files can be accidentally committed to version control and are visible in plain text
- Using an input variable in `variables.tf` – Variables can still end up in state files or plan output, and may require passing sensitive values via command line or `.tfvars` files

**Example / Command:**

```bash
# Set credentials as environment variables (Linux/macOS)
export AWS_ACCESS_KEY_ID="<access_key>"
export AWS_SECRET_ACCESS_KEY="<secret_key>"

# Terraform will automatically pick up these values
terraform init
terraform apply
```

```hcl
# AVOID this (credentials in code):
backend "s3" {
  bucket     = "my-terraform-state"
  key        = "terraform.tfstate"
  region     = "us-east-1"
  access_key = "NEVER_DO_THIS"
  secret_key = "NEVER_DO_THIS"
}
```

**Key Takeaway:**
Always store credentials in environment variables outside of Terraform to prevent exposure in code or state files.

---

### Question 4

**Question:** Beyond storing state, what capability can an enhanced storage backend, such as the remote backend, provide your organization?

**Correct Answer:**

- Execute your Terraform on infrastructure either locally or in Terraform Cloud

**Explanation:**
Enhanced backends (like the `remote` backend used with Terraform Cloud) go beyond simple state storage. They provide the ability to execute Terraform operations remotely in Terraform Cloud, or locally while still using remote state. This enables features like remote runs, policy enforcement, and centralized execution.

**Why the other options are incorrect:**

- Replicate state to a secondary location for backup – While some backends support versioning, replication isn't a core enhanced backend feature
- Allow multiple people to execute operations at the same time – State locking actually prevents this to avoid conflicts
- Provides versioning capabilities on your state file – While Terraform Cloud does version state, the defining feature of an enhanced backend is remote execution capability

**Example / Command:**

```hcl
# Enhanced backend configuration for Terraform Cloud
terraform {
  backend "remote" {
    organization = "my-org"

    workspaces {
      name = "my-workspace"
    }
  }
}
```

**Standard vs Enhanced Backends:**
| Feature | Standard Backend | Enhanced Backend |
|---------|-----------------|-----------------|
| Store state | ✅ | ✅ |
| State locking | ✅ | ✅ |
| Remote execution | ❌ | ✅ |

**Key Takeaway:**
Enhanced backends provide remote execution capabilities in addition to state storage and locking.

---

### Question 5

**Question:** Your organization has multiple engineers that have permission to manage Terraform as well as administrative access to the public cloud where these resources are provisioned. If an engineer makes a change outside of Terraform, what command can you run to detect drift and update the state file?

**Correct Answer:**

- `terraform apply -refresh-only`

**Explanation:**
The `terraform apply -refresh-only` command refreshes the state file to match real-world infrastructure without making any changes to actual resources. It detects drift caused by out-of-band changes (manual changes made outside of Terraform) and updates the state file accordingly, while still requiring approval before writing changes to state.

**Why the other options are incorrect:**

- `terraform init` – Initializes the working directory, downloads providers and modules; does not refresh state
- `terraform state list` – Lists resources tracked in state but doesn't detect or reconcile drift
- `terraform get` – Downloads and updates modules referenced in configurations; doesn't interact with state

**Example / Command:**

```bash
# Detect drift and update state (recommended approach)
terraform apply -refresh-only

# Deprecated alternative (may still appear on exam)
terraform refresh
```

**Important Note:** `terraform refresh` is deprecated but may still appear on the Terraform Associate 003 exam. The recommended replacement is `terraform apply -refresh-only`, which provides the same functionality with the added safety of requiring explicit approval.

**Key Takeaway:**
Use `terraform apply -refresh-only` to detect drift from out-of-band changes and update the state file without modifying infrastructure.

---

## Summary

This quiz covers essential Terraform state management concepts:

- **State Storage**: Default location is `terraform.tfstate` on local backend
- **State Locking**: Prevents concurrent writes to state, ensuring safe collaboration
- **Credential Security**: Store credentials in environment variables outside of Terraform
- **Enhanced Backends**: Provide remote execution in addition to state storage
- **Drift Detection**: Use `terraform apply -refresh-only` to reconcile state with actual infrastructure

Proper state management is critical for team collaboration, security, and reliable infrastructure management with Terraform.
