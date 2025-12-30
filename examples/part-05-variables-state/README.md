# Part 5: Variables, Outputs & State

Demonstrate input variables, outputs, sensitive data handling, and state management.

## What You'll Learn
- Define and use input variables with validation
- Handle sensitive data (passwords, secrets)
- Create outputs for resource information
- Manage Terraform state
- Use environment-specific configuration files

## Prerequisites
- AWS account configured (see Part 2)
- AWS credentials set up
- Terraform 1.6+ installed

## Directory Contents

- `variables.tf` - Input variable definitions with validation
- `main.tf` - EC2 instances with security group
- `outputs.tf` - Output definitions (simple, structured, sensitive)
- `user-data.sh` - Instance initialization script
- `dev.tfvars` - Development environment variables
- `prod.tfvars` - Production environment variables
- `terraform.tfvars.example` - Example variable values template
- `state-inspection.sh` - Helper script for state commands

## Usage

### 1. Copy Example Variables
```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 2. Set Sensitive Variables
```bash
# NEVER hardcode passwords in .tfvars files!
# Use environment variables instead:
export TF_VAR_db_password="your-secure-password-min-16-chars"
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Plan with Environment-Specific Variables
```bash
# Development environment
terraform plan -var-file="dev.tfvars"

# Production environment
terraform plan -var-file="prod.tfvars"
```

### 5. Apply Configuration
```bash
# Apply with dev settings
terraform apply -var-file="dev.tfvars"

# Type "yes" to confirm
```

### 6. View Outputs
```bash
# Show all outputs
terraform output

# Show specific output
terraform output instance_ids

# Show sensitive output (requires explicit flag)
terraform output -json db_connection_string
```

### 7. Inspect State
```bash
# List all resources in state
terraform state list

# Show detailed resource info
terraform state show aws_instance.web[0]

# View state file (not recommended for direct editing)
cat terraform.tfstate
```

### 8. Clean Up
```bash
terraform destroy -var-file="dev.tfvars"
```

## Variable Validation Examples

This example demonstrates several validation patterns:

### String Validation
```hcl
variable "environment" {
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### Number Range Validation
```hcl
variable "instance_count" {
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "Instance count must be between 1 and 10."
  }
}
```

### Regex Validation
```hcl
variable "instance_type" {
  validation {
    condition     = can(regex("^t[23]\\.(micro|small|medium|large)$", var.instance_type))
    error_message = "Instance type must be t2 or t3 family."
  }
}
```

### Length Validation
```hcl
variable "db_password" {
  validation {
    condition     = length(var.db_password) >= 16
    error_message = "Database password must be at least 16 characters."
  }
}
```

## Output Types

### Simple Outputs
Direct values from variables or resources:
```hcl
output "region" {
  value = var.aws_region
}
```

### List Outputs (Splat Syntax)
Get attributes from multiple instances:
```hcl
output "instance_ids" {
  value = aws_instance.web[*].id
}
```

### Structured Outputs
Complex objects with for expressions:
```hcl
output "instance_details" {
  value = [
    for instance in aws_instance.web : {
      id         = instance.id
      public_ip  = instance.public_ip
      az         = instance.availability_zone
    }
  ]
}
```

### Sensitive Outputs
Hide from console output (passwords, connection strings):
```hcl
output "db_connection_string" {
  value     = local.db_connection_string
  sensitive = true
}
```

## State Management Commands

### Inspection
```bash
# List resources
terraform state list

# Show resource details
terraform state show aws_instance.web[0]

# Pull remote state (if using remote backend)
terraform state pull > local-state.json
```

### Manipulation (Advanced)
```bash
# Move resource to different address
terraform state mv aws_instance.web[0] aws_instance.web_primary

# Remove resource from state (doesn't destroy it)
terraform state rm aws_instance.web[1]

# Import existing resource
terraform import aws_instance.web[2] i-1234567890abcdef0
```

## Cost Warning
⚠️ **This creates real AWS resources that may incur charges.**

- t2.micro is free tier eligible (750 hours/month first year)
- t3.medium in prod.tfvars will incur charges (~$30/month)
- EBS volumes incur storage charges
- Always run `terraform destroy` when done experimenting

## Troubleshooting

**Error: "variable has no default value"**
- Ensure required variables are set in .tfvars or environment
- Use `export TF_VAR_variable_name=value` for sensitive vars

**Error: "Invalid value for variable"**
- Check validation constraints in variables.tf
- Ensure values match expected types (string, number, bool)

**Error: "No valid credential sources found"**
- Run `aws configure` to set up credentials
- Verify `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are set

**State is out of sync**
- Run `terraform refresh` to update state
- Use `terraform plan` to see drift from desired state

## Security Best Practices

1. **Never commit secrets to git**
   - Add `*.tfvars` to .gitignore (except .example files)
   - Use environment variables: `TF_VAR_*`
   - Use secret management: AWS Secrets Manager, Vault

2. **Use sensitive = true**
   - Mark password variables as sensitive
   - Mark password outputs as sensitive
   - Prevents accidental logging

3. **Encrypt state files**
   - Use S3 backend with encryption (see Part 9)
   - Enable state locking with DynamoDB
   - Restrict state file access with IAM

## Next Steps

After completing this example:
- Read blog post to understand variable precedence
- Learn about tfvars file hierarchy
- Explore remote state backends (Part 9)
- Study output dependency chains

## References
- [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)
- [Terraform Outputs](https://developer.hashicorp.com/terraform/language/values/outputs)
- [Terraform State](https://developer.hashicorp.com/terraform/language/state)
