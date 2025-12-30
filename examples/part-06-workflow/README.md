# Part 6: Terraform Workflow

Demonstrate core Terraform CLI commands and workflow best practices.

## What You'll Learn
- Initialize Terraform projects (`terraform init`)
- Format code (`terraform fmt`)
- Validate configurations (`terraform validate`)
- Plan infrastructure changes (`terraform plan`)
- Apply changes (`terraform apply`)
- Destroy resources (`terraform destroy`)
- Inspect and manipulate state
- Work with workspaces for environment isolation
- Import existing resources
- Debug with TF_LOG

## Prerequisites
- AWS account configured (see Part 2)
- AWS credentials set up
- Terraform 1.6+ installed

## Directory Contents

- `main.tf` - Simple S3 bucket and DynamoDB table
- `outputs.tf` - Resource outputs
- `workflow-demo.sh` - Interactive workflow demonstration script
- `import-example.sh` - Example of importing existing resources

## Complete Workflow Walkthrough

### 1. Initialize Project
```bash
# Download provider plugins and initialize backend
terraform init

# Output shows:
# - Provider versions downloaded
# - Backend initialized
# - Lock file created (.terraform.lock.hcl)
```

### 2. Format Code
```bash
# Format all .tf files in current directory
terraform fmt

# Check formatting without making changes
terraform fmt -check

# Format files recursively
terraform fmt -recursive

# Show diff of formatting changes
terraform fmt -diff
```

### 3. Validate Configuration
```bash
# Check syntax and internal consistency
terraform validate

# Output shows validation errors or success message
# Does NOT check provider credentials or API access
```

### 4. Plan Changes
```bash
# Preview what Terraform will do
terraform plan

# Save plan to file for later apply
terraform plan -out=tfplan

# Show plan in JSON format (useful for automation)
terraform plan -json

# Target specific resource for planning
terraform plan -target=aws_s3_bucket.example
```

### 5. Apply Changes
```bash
# Apply with interactive confirmation
terraform apply

# Apply saved plan (no confirmation prompt)
terraform apply tfplan

# Apply with auto-approval (use with caution!)
terraform apply -auto-approve

# Apply targeting specific resource
terraform apply -target=aws_s3_bucket.example
```

### 6. Inspect State
```bash
# List all resources in state
terraform state list

# Show detailed resource information
terraform state show aws_s3_bucket.example

# Pull remote state to stdout
terraform state pull

# Get specific output value
terraform output bucket_name
terraform output -json  # All outputs as JSON
```

### 7. Make Changes
```bash
# Modify main.tf (e.g., add tags, change configuration)
vim main.tf

# Preview changes
terraform plan

# Apply changes
terraform apply
```

### 8. Refresh State
```bash
# Update state to match real infrastructure
# (Deprecated in Terraform 1.5+, use plan/apply with -refresh-only)
terraform apply -refresh-only

# Preview refresh without making state changes
terraform plan -refresh-only
```

### 9. Destroy Resources
```bash
# Destroy all resources (interactive confirmation)
terraform destroy

# Destroy with auto-approval
terraform destroy -auto-approve

# Destroy specific resource only
terraform destroy -target=aws_s3_bucket.example
```

## State Manipulation Commands

### List Resources
```bash
terraform state list
```

### Show Resource Details
```bash
terraform state show aws_s3_bucket.example
```

### Move Resource (Rename)
```bash
# Rename resource in state without recreating
terraform state mv aws_s3_bucket.example aws_s3_bucket.renamed
```

### Remove Resource from State
```bash
# Remove from Terraform management (doesn't delete resource)
terraform state rm aws_s3_bucket.example
```

### Import Existing Resource
```bash
# Import existing S3 bucket into Terraform state
terraform import aws_s3_bucket.example my-existing-bucket-name

# See import-example.sh for complete workflow
```

## Workspace Management

Workspaces allow multiple state files for the same configuration.

### List Workspaces
```bash
terraform workspace list
```

### Create New Workspace
```bash
terraform workspace new dev
terraform workspace new staging
terraform workspace new prod
```

### Switch Workspace
```bash
terraform workspace select dev
```

### Show Current Workspace
```bash
terraform workspace show
```

### Delete Workspace
```bash
# Must not be current workspace
terraform workspace select default
terraform workspace delete dev
```

### Use Workspace in Configuration
```hcl
resource "aws_s3_bucket" "example" {
  bucket = "myapp-${terraform.workspace}-bucket"
  # dev -> myapp-dev-bucket
  # prod -> myapp-prod-bucket
}
```

## Debugging with TF_LOG

Enable detailed logging for troubleshooting:

```bash
# Set log level (TRACE, DEBUG, INFO, WARN, ERROR)
export TF_LOG=DEBUG
terraform plan

# Log to file
export TF_LOG=TRACE
export TF_LOG_PATH=terraform-debug.log
terraform apply

# Disable logging
unset TF_LOG
unset TF_LOG_PATH
```

### Log Levels
- **TRACE**: Most verbose, shows all internal operations
- **DEBUG**: Detailed debugging information
- **INFO**: General informational messages
- **WARN**: Warning messages
- **ERROR**: Error messages only

## Advanced Workflow Patterns

### Plan → Review → Apply
```bash
# 1. Generate plan file
terraform plan -out=tfplan

# 2. Review plan (human or automation)
terraform show tfplan

# 3. Apply exact plan (no confirmation needed)
terraform apply tfplan

# 4. Clean up plan file
rm tfplan
```

### Targeted Apply (Use Sparingly)
```bash
# Only apply changes to specific resource and dependencies
terraform apply -target=aws_s3_bucket.example

# Warning: Can lead to inconsistent state
# Use only for emergency fixes or development
```

### Replace Resource (Force Recreation)
```bash
# Force replacement of specific resource
terraform apply -replace=aws_s3_bucket.example

# Replaces taint command (deprecated in Terraform 1.5+)
```

### Parallelism Control
```bash
# Limit concurrent operations (default: 10)
terraform apply -parallelism=5

# Useful for:
# - Rate limit sensitive APIs
# - Reduce load on provider endpoints
# - Debugging race conditions
```

## Common Workflow Scenarios

### Scenario 1: First Time Setup
```bash
terraform init
terraform plan
terraform apply
```

### Scenario 2: Update Configuration
```bash
# Edit .tf files
terraform fmt
terraform validate
terraform plan
terraform apply
```

### Scenario 3: Import Existing Resources
```bash
# 1. Write resource block (empty or with known attributes)
# 2. Import resource
terraform import aws_s3_bucket.existing my-bucket-name
# 3. Run plan to see remaining differences
terraform plan
# 4. Update configuration to match reality
# 5. Verify plan shows no changes
terraform plan
```

### Scenario 4: Disaster Recovery
```bash
# State file lost or corrupted
# 1. Restore from backup (.terraform.tfstate.backup)
# 2. Or import all resources one by one
# 3. Or destroy and recreate (last resort)
```

### Scenario 5: Team Collaboration
```bash
# 1. Pull latest code
git pull

# 2. Initialize (in case providers changed)
terraform init

# 3. Plan changes
terraform plan

# 4. Apply only if plan looks correct
terraform apply

# 5. Commit state if using VCS (NOT recommended)
# Use remote backend instead (see Part 9)
```

## Best Practices

### ✅ DO
- Always run `terraform plan` before `apply`
- Use `-out` flag for plan → apply workflow in automation
- Format code before committing: `terraform fmt -recursive`
- Validate before push: `terraform validate`
- Use workspaces for environment isolation
- Enable debug logs when troubleshooting
- Review state changes carefully
- Use remote state for teams (see Part 9)

### ❌ DON'T
- Don't use `terraform apply -auto-approve` in production
- Don't edit state files directly (use `terraform state` commands)
- Don't commit state files to Git (use remote backend)
- Don't overuse `-target` (can create inconsistent state)
- Don't ignore plan output (read it carefully!)
- Don't skip `terraform init` after pulling changes
- Don't run multiple `apply` commands concurrently

## Workflow Automation (CI/CD Preview)

### GitHub Actions Example
```yaml
- name: Terraform Plan
  run: |
    terraform init
    terraform plan -out=tfplan

- name: Terraform Apply
  if: github.ref == 'refs/heads/main'
  run: terraform apply -auto-approve tfplan
```

Full CI/CD examples in Part 12.

## Cost Warning
⚠️ **This creates real AWS resources:**
- S3 bucket (minimal cost, mostly free tier)
- DynamoDB table (pay-per-request mode, minimal cost)
- Always run `terraform destroy` when done

## Troubleshooting

**Error: "Backend initialization required"**
- Run `terraform init` before other commands

**Error: "No valid credential sources"**
- Configure AWS credentials: `aws configure`

**Error: "Resource already exists"**
- Use `terraform import` to bring existing resource into state

**Error: "State lock already held"**
- Another terraform process is running
- Or previous process crashed: `terraform force-unlock <lock-id>`

**Error: "Inconsistent dependency lock file"**
- Providers changed: `terraform init -upgrade`

## Interactive Demo

Run the included workflow demonstration:
```bash
./workflow-demo.sh
```

This script walks through the complete Terraform workflow interactively.

## Next Steps

- Learn module patterns (Part 7)
- Set up remote state backends (Part 9)
- Integrate with CI/CD (Part 12)

## References
- [Terraform CLI Documentation](https://developer.hashicorp.com/terraform/cli)
- [Terraform Workflow](https://developer.hashicorp.com/terraform/intro/core-workflow)
- [State Command](https://developer.hashicorp.com/terraform/cli/commands/state)
