# Troubleshooting Guide

Common issues and solutions for the Terraform HCL Tutorial Series.

## Table of Contents

- [Installation Issues](#installation-issues)
- [Authentication Problems](#authentication-problems)
- [Terraform Errors](#terraform-errors)
- [Provider Issues](#provider-issues)
- [State Management](#state-management)
- [Performance Issues](#performance-issues)

---

## Installation Issues

### Terraform Version Mismatch

**Problem**: "Required version constraint not met"

**Solution**:
```bash
# Check current version
terraform version

# Install specific version (using asdf)
asdf install terraform 1.6.6
asdf global terraform 1.6.6

# Or download from HashiCorp
# https://developer.hashicorp.com/terraform/install
```

### Missing Cloud CLI Tools

**Problem**: "aws: command not found" (or gcloud, az)

**Solution**:
- AWS CLI: https://aws.amazon.com/cli/
- GCP SDK: https://cloud.google.com/sdk/docs/install
- Azure CLI: https://learn.microsoft.com/cli/azure/install-azure-cli

---

## Authentication Problems

### AWS Authentication Failures

**Error**: `Error: No valid credential sources found`

**Solutions**:

1. **Check environment variables**:
   ```bash
   echo $AWS_ACCESS_KEY_ID
   echo $AWS_SECRET_ACCESS_KEY
   echo $AWS_DEFAULT_REGION
   ```

2. **Verify AWS CLI configuration**:
   ```bash
   aws sts get-caller-identity
   cat ~/.aws/credentials
   ```

3. **Test provider**:
   ```bash
   cd examples/part-02-setup/aws/
   terraform init
   terraform plan
   ```

### GCP Authentication Failures

**Error**: `Error: google: could not find default credentials`

**Solutions**:

1. **Set credentials environment variable**:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account.json"
   ```

2. **Use gcloud auth**:
   ```bash
   gcloud auth application-default login
   ```

3. **Verify credentials**:
   ```bash
   gcloud auth list
   gcloud config list project
   ```

### Azure Authentication Failures

**Error**: `Error: building account: obtaining auth token from CLI`

**Solutions**:

1. **Login via Azure CLI**:
   ```bash
   az login
   ```

2. **Set subscription**:
   ```bash
   az account list
   az account set --subscription "your-subscription-id"
   ```

3. **Verify authentication**:
   ```bash
   az account show
   ```

---

## Terraform Errors

### State Lock Errors

**Error**: `Error acquiring the state lock`

**Cause**: Previous terraform process didn't release lock

**Solution**:
```bash
# Force unlock (use with caution!)
terraform force-unlock LOCK_ID

# Or wait for lock timeout
# Or ensure no other terraform processes are running
```

### Resource Already Exists

**Error**: `Error: resource already exists`

**Cause**: Resource exists but not in state file

**Solution**:
```bash
# Import existing resource
terraform import aws_instance.web i-1234567890abcdef0

# Or destroy and recreate
terraform destroy -target=aws_instance.web
terraform apply
```

### Plugin/Provider Errors

**Error**: `Error installing provider "aws"`

**Solutions**:

1. **Clear provider cache**:
   ```bash
   rm -rf .terraform/
   rm .terraform.lock.hcl
   terraform init
   ```

2. **Update provider version**:
   ```hcl
   required_providers {
     aws = {
       source  = "hashicorp/aws"
       version = "~> 5.0"  # Update version
     }
   }
   ```

3. **Check network connectivity**:
   ```bash
   curl -I https://registry.terraform.io
   ```

---

## Provider Issues

### AWS Region Not Found

**Error**: `InvalidAMIID.NotFound` or `InvalidSubnetID.NotFound`

**Cause**: Resource IDs are region-specific

**Solution**:
```hcl
# Use data sources instead of hardcoded IDs
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id  # Dynamic
}
```

### GCP Project Not Set

**Error**: `Error 403: Project not found or permission denied`

**Solution**:
```hcl
# Explicitly set project in provider
provider "google" {
  project = "your-project-id"
  region  = "us-central1"
}
```

```bash
# Or set via environment variable
export GOOGLE_PROJECT="your-project-id"
```

### Azure Resource Group Issues

**Error**: `Error: Resource group not found`

**Cause**: Azure requires explicit resource group creation

**Solution**:
```hcl
# Always create resource group first
resource "azurerm_resource_group" "main" {
  name     = "my-resources"
  location = "East US"
}

# Reference in other resources
resource "azurerm_virtual_network" "main" {
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  # ...
}
```

---

## State Management

### State File Corruption

**Symptoms**: Inconsistent state, resources missing from state

**Recovery**:
```bash
# Pull latest state
terraform state pull > backup.tfstate

# Refresh state from real infrastructure
terraform refresh

# Or import missing resources
terraform import <resource_type>.<name> <id>
```

### State Drift

**Problem**: State doesn't match real infrastructure

**Detection**:
```bash
# Check for drift
terraform plan
# Look for unexpected changes

# Refresh state to match reality
terraform refresh
```

**Prevention**:
- Use remote state with locking
- Don't manually modify infrastructure
- Run `terraform plan` before `apply`

---

## Performance Issues

### Slow `terraform plan`

**Causes**:
- Too many resources
- Slow network
- Large state file

**Solutions**:
```bash
# Use targeted plans
terraform plan -target=aws_instance.web

# Parallelize operations
terraform plan -parallelism=20

# Use local state cache (remote backend)
# Configure backend with reduced latency
```

### Timeout Errors

**Error**: `Error waiting for instance to become ready`

**Solutions**:
```hcl
# Increase timeouts
resource "aws_instance" "web" {
  # ...

  timeouts {
    create = "60m"
    delete = "2h"
  }
}
```

---

## Cost-Related Issues

### Unexpected Charges

**Problem**: Cloud bill higher than expected

**Prevention**:
1. **Set billing alerts** in cloud console
2. **Use cost calculators** before deploying
3. **Tag resources** for cost tracking
4. **Always destroy when done**: `terraform destroy`

**Verification**:
```bash
# List all resources in state
terraform state list

# Verify all resources destroyed
terraform show
# Should show empty or minimal resources
```

---

## Getting More Help

If your issue isn't covered here:

1. **Check official docs**:
   - [Terraform Troubleshooting](https://developer.hashicorp.com/terraform/tutorials/configuration-language/troubleshooting-workflow)
   - Provider-specific documentation

2. **Search GitHub Issues**:
   - [Repository Issues](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues)
   - [Terraform GitHub](https://github.com/hashicorp/terraform/issues)

3. **Community Support**:
   - [HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core)
   - [Terraform Discord](https://discord.com/invite/terraform)
   - [Stack Overflow](https://stackoverflow.com/questions/tagged/terraform)

4. **Create an Issue**:
   - [Report a Bug](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues/new?template=bug_report.md)

---

**Pro Tip**: Enable debug logging for detailed error information:
```bash
export TF_LOG=DEBUG
terraform plan 2>&1 | tee terraform-debug.log
```
