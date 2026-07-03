# Quiz 8 - Read, Generate, and Modify Configuration

### Question 1

**Question:** True or False? Input variables that are marked as `sensitive` are NOT written to Terraform state.

**Correct Answer:**

- False

**Explanation:**

- Marking a variable as `sensitive = true` only affects Terraform's **CLI output** — it prevents the value from being displayed in `plan`, `apply`, and `output` logs.
- The actual value is still written **in plain text** to the Terraform state file. Sensitivity is a display-layer protection, not an encryption or storage protection mechanism.
- This is why securing your state file (via a remote backend with encryption, restricted access, and versioning — e.g., S3 + DynamoDB with encryption enabled) is critical, even when using sensitive variables.

**Why the other option is incorrect:**

- **True** – Incorrect, because this implies sensitive values are excluded from state entirely, which is false. They are hidden from output, not from storage.

**Example:**

```hcl
variable "db_password" {
  type      = string
  sensitive = true
}
```

**Key Takeaway:**

- `sensitive = true` hides values from CLI output only — it does **not** encrypt or omit them from the state file.

---

### Question 2

**Question:** You need to input variables that follow a key/value type structure. What type of variable would be used?

**Correct Answer:**

- `map`

**Explanation:**

- A `map` variable stores data as key/value pairs, making it the natural choice when you need to associate a set of names (keys) with corresponding values — e.g., environment names mapped to instance sizes.

**Why the other options are incorrect:**

- **List of strings** – Stores an ordered collection of values only; no keys, so no key/value association.
- **String** – Holds a single scalar value; cannot represent multiple key/value pairs.
- **Array** – Not a native Terraform variable type (Terraform uses `list`/`tuple`); even if it were, arrays are index-based, not key-based.

**Example:**

```hcl
variable "instance_types" {
  type = map(string)
  default = {
    dev  = "t2.micro"
    prod = "t3.large"
  }
}
```

**Key Takeaway:**

- Use `map` whenever your data is naturally expressed as key/value pairs.

---

### Question 3

**Question:** Which of the following allows you to set the value of a Terraform input variable using an environment variable?

**Correct Answer:**

- A command using the `TF_VAR_<variable_name>` naming convention, e.g. `export TF_VAR_db_password=P@ssw0rd123`

**Explanation:**

- Terraform automatically reads environment variables prefixed with `TF_VAR_` and maps them to matching input variable names. This is a common way to pass sensitive values (like passwords) without hardcoding them in `.tfvars` files or committing them to source control.

**Why the other options are incorrect:**

- `export VAR_database=prodsql01` – Uses the wrong prefix (`VAR_` instead of `TF_VAR_`); Terraform will not recognize it.
- Any option missing the `TF_VAR_` prefix or misformatted (e.g., missing underscore, wrong variable name syntax) – Terraform only recognizes exactly `TF_VAR_<name>`.

**Example:**

```bash
export TF_VAR_db_user="dbadmin01"
export TF_VAR_db_password="P@ssw0rd123"
terraform apply
```

**Key Takeaway:**

- Environment variables must follow the exact `TF_VAR_<variable_name>` format to be picked up by Terraform.

---

### Question 4

**Question:** Given the code snippet below, what is the managed resource name for this resource?

```hcl
resource "aws_vpc" "prod-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name        = var.vpc_name
    Environment = "demo_environment"
    Terraform   = "true"
  }
}
```

**Correct Answer:**

- `prod-vpc`

**Explanation:**

- In a Terraform `resource` block, the syntax is:
  ```
  resource "<RESOURCE_TYPE>" "<RESOURCE_NAME>" { ... }
  ```
- `aws_vpc` is the **resource type** (the AWS provider's VPC resource). `prod-vpc` is the **local/managed resource name** — the identifier used to reference this resource elsewhere in your configuration (e.g., `aws_vpc.prod-vpc.id`).

**Why the other options are incorrect:**

- `aws_vpc` – This is the resource **type**, not the name.
- `resource.aws_vpc` – Not valid Terraform reference syntax; you reference resources as `<type>.<name>`, not `resource.<type>`.
- `demo_environment` – This is a **tag value** inside the resource, unrelated to the resource's identifier.

**Key Takeaway:**

- In `resource "TYPE" "NAME"`, the second string is the managed resource name used for references (`TYPE.NAME`).

---

### Question 5

**Question:** Given the code snippet below, how would you reference the `arn` retrieved by the data block in an output?

```hcl
data "aws_s3_bucket" "data-bucket" {
  bucket = "my-data-lookup-bucket-01"
}

output "s3_bucket_arn" {
  value = ???
}
```

**Correct Answer:**

- `data.aws_s3_bucket.data-bucket.arn`

**Explanation:**

- Data sources are referenced using the pattern:
  ```
  data.<DATA_SOURCE_TYPE>.<DATA_SOURCE_NAME>.<ATTRIBUTE>
  ```
- Here, `aws_s3_bucket` is the data source type, `data-bucket` is the local name assigned in the `data` block, and `arn` is the attribute exported by that data source.

**Why the other options are incorrect:**

- `data.aws_s3_bucket.arn` – Skips the data source's local name (`data-bucket`), so Terraform cannot resolve which data block it refers to.
- `aws_s3_bucket.data-bucket` – Missing the `data.` prefix, which is required to distinguish data sources from managed resources; also missing the `.arn` attribute.
- `data.aws_s3_bucket.data-bucket` – Missing the `.arn` attribute reference, so it would return the whole object, not the ARN specifically.

**Example:**

```hcl
output "s3_bucket_arn" {
  value = data.aws_s3_bucket.data-bucket.arn
}
```

**Key Takeaway:**

- Always reference data sources as `data.<TYPE>.<NAME>.<ATTRIBUTE>` — the `data.` prefix and the local name are both required.
