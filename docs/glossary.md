# Terraform Glossary

Essential Terraform terminology used throughout the tutorial series.

## Core Concepts

### Terraform
Open-source Infrastructure as Code (IaC) tool by HashiCorp that allows you to define, provision, and manage cloud infrastructure using declarative configuration files.

### Infrastructure as Code (IaC)
Practice of managing and provisioning infrastructure through machine-readable configuration files rather than manual processes or interactive configuration tools.

### HashiCorp Configuration Language (HCL)
Domain-specific language designed for Terraform configurations. Human-readable and declarative, optimized for infrastructure definitions.

### Declarative
Programming paradigm where you describe the desired end state, and Terraform determines how to achieve it. Opposite of imperative (step-by-step instructions).

---

## Terraform Workflow

### `terraform init`
Initialize a Terraform working directory by downloading required providers and modules. Always run first in a new directory.

### `terraform plan`
Preview changes Terraform will make to reach desired state. Shows additions, modifications, and deletions before applying.

### `terraform apply`
Execute the changes proposed in a plan. Creates, updates, or deletes infrastructure to match configuration.

### `terraform destroy`
Remove all infrastructure managed by Terraform in the current workspace. Use with caution!

### `terraform fmt`
Automatically format Terraform configuration files to canonical style. Useful for consistent code formatting.

### `terraform validate`
Check configuration syntax and internal consistency without accessing remote services.

---

## Configuration Elements

### Resource
Infrastructure component managed by Terraform (e.g., virtual machine, database, network). Defined with `resource` block.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

### Data Source
Read-only information fetched from providers. Used to reference existing infrastructure or fetch dynamic data.

```hcl
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
}
```

### Variable
Input parameter that customizes Terraform configurations. Defined with `variable` block.

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

### Output
Value exported from a module or configuration. Useful for displaying information or passing to other configurations.

```hcl
output "instance_id" {
  value = aws_instance.web.id
}
```

### Local Value
Named value computed within a module. Used for DRY (Don't Repeat Yourself) principles.

```hcl
locals {
  common_tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}
```

### Module
Container for multiple resources that are used together. Reusable package of Terraform configurations.

---

## State Management

### State File (`terraform.tfstate`)
JSON file tracking the current state of managed infrastructure. Maps configuration to real-world resources.

### Backend
Storage location for state files (local, S3, GCS, Azure Blob, Terraform Cloud). Enables team collaboration.

### State Locking
Mechanism to prevent concurrent modifications to state file. Critical for team workflows.

### Remote State
State file stored remotely (not on local filesystem). Enables collaboration and centralized management.

### Workspace
Named isolation of state within the same configuration. Allows managing multiple environments (dev, staging, prod).

---

## Providers

### Provider
Plugin that interfaces with cloud platforms and services (AWS, GCP, Azure, etc.). Defines available resources and data sources.

```hcl
provider "aws" {
  region = "us-west-2"
}
```

### Provider Version
Specific release of a provider plugin. Locked to ensure consistent behavior.

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

### Provider Alias
Multiple configurations of the same provider (e.g., different AWS regions or accounts).

```hcl
provider "aws" {
  alias  = "us_east"
  region = "us-east-1"
}
```

---

## Advanced Concepts

### Dependency Graph
Internal representation of resource relationships. Terraform uses this to determine execution order.

### Implicit Dependency
Automatic dependency created by referencing one resource's attribute in another.

### Explicit Dependency
Manual dependency declared using `depends_on` argument. Use when implicit isn't sufficient.

### Drift
Difference between Terraform state and actual infrastructure. Occurs when infrastructure is modified outside Terraform.

### Taint
Mark a resource for recreation on next apply. Useful for forcing replacement without deleting configuration.

### Provisioner
Execute scripts or commands on resources after creation. Generally discouraged; prefer cloud-init or configuration management tools.

### Lifecycle
Rules controlling resource creation, update, and deletion behavior.

```hcl
lifecycle {
  create_before_destroy = true
  prevent_destroy       = true
  ignore_changes        = [tags]
}
```

---

## Expressions

### Interpolation
Embed expressions within strings using `${}` syntax.

```hcl
name = "${var.environment}-web-server"
```

### For Expression
Transform collections using iteration.

```hcl
[for s in var.subnets : s.cidr_block]
```

### Conditional Expression
Ternary operator for conditional logic.

```hcl
instance_type = var.env == "prod" ? "t3.large" : "t2.micro"
```

### Splat Expression
Shorthand for extracting attributes from lists.

```hcl
aws_instance.web[*].id
```

---

## Types

### Primitive Types
- `string`: Text value
- `number`: Numeric value
- `bool`: True or false

### Complex Types
- `list(type)`: Ordered sequence
- `map(type)`: Key-value pairs
- `set(type)`: Unique values
- `object({...})`: Structured data
- `tuple([...])`: Fixed-length, mixed types

---

## Built-in Functions

### String Functions
- `format()`: Printf-style formatting
- `join()`: Combine list into string
- `split()`: String to list
- `replace()`: Find and replace

### Collection Functions
- `length()`: Size of collection
- `lookup()`: Get value from map
- `merge()`: Combine maps
- `keys()` / `values()`: Extract from maps

### Filesystem Functions
- `file()`: Read file contents
- `templatefile()`: Render template
- `filebase64()`: Base64 encode file

### Type Conversion
- `tostring()`, `tonumber()`, `tobool()`
- `tolist()`, `tomap()`, `toset()`

---

## Testing & Validation

### Terratest
Go-based testing framework for Terraform. Allows integration testing of infrastructure code.

### tfsec
Static analysis security scanner for Terraform code. Detects potential security issues.

### OPA (Open Policy Agent)
Policy-as-code framework. Enforce compliance rules on Terraform configurations.

### Conftest
Tool for writing tests against structured configuration data using OPA.

---

## Production Concepts

### Sentinel
HashiCorp's policy-as-code framework. Enterprise feature for Terraform Cloud/Enterprise.

### Cost Estimation
Feature in Terraform Cloud showing estimated infrastructure costs before apply.

### VCS (Version Control System)
Integration with Git providers (GitHub, GitLab, Bitbucket) for automated Terraform runs.

### Blast Radius
Scope of impact if something goes wrong. Minimize by using workspaces, modules, and targeted applies.

---

## Abbreviations

- **IaC**: Infrastructure as Code
- **HCL**: HashiCorp Configuration Language
- **TF**: Terraform (informal)
- **VCS**: Version Control System
- **CI/CD**: Continuous Integration/Continuous Deployment
- **SOPS**: Secrets OPerationS (encryption tool)
- **OIDC**: OpenID Connect (authentication protocol)
- **IAM**: Identity and Access Management

---

## Related Tools

### Terragrunt
Wrapper for Terraform providing DRY configurations, state locking, and more.

### Atlantis
Self-hosted Terraform pull request automation server.

### Terraform Cloud
HashiCorp's managed service for Terraform, including state management, CI/CD, and team collaboration.

### Vault
HashiCorp's secrets management tool. Integrates with Terraform for dynamic credentials.

### Packer
HashiCorp's tool for building machine images. Often used before Terraform for image creation.

---

**See Also**:
- [Official Terraform Glossary](https://developer.hashicorp.com/terraform/docs/glossary)
- [Terraform Language Reference](https://developer.hashicorp.com/terraform/language)
