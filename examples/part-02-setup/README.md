# Part 2: Setting Up Terraform

Learn how to install Terraform and configure cloud provider authentication for AWS, GCP, and Azure.

**📚 Read the full tutorial**: [Part 2: Setting Up Terraform](#) *(coming soon)*

---

## Overview

This part covers the essential setup steps before you can deploy infrastructure with Terraform:

- Installing Terraform CLI
- Configuring cloud provider authentication
- Understanding provider concepts and versioning
- Initializing your first Terraform project
- Validating provider connectivity

## What You'll Build

Simple validation examples that verify your provider configuration without creating costly resources. Each example reads account/project information to confirm authentication works.

**No infrastructure created** - these examples only validate your setup!

---

## Prerequisites

### Required Tools

Install these before starting:

1. **Terraform CLI** (1.6.0+)
   - macOS: `brew install terraform`
   - Linux: [Download from HashiCorp](https://developer.hashicorp.com/terraform/install)
   - Windows: [Chocolatey](https://chocolatey.org/packages/terraform) or direct download

2. **Cloud CLI Tools** (choose your cloud):
   - **AWS CLI**: [Install Guide](https://aws.amazon.com/cli/)
   - **gcloud SDK**: [Install Guide](https://cloud.google.com/sdk/docs/install)
   - **Azure CLI**: [Install Guide](https://learn.microsoft.com/cli/azure/install-azure-cli)

**Verify installations**:
```bash
# From repository root
./scripts/check-prerequisites.sh
```

### Cloud Accounts

You'll need at least one cloud account:
- **AWS**: [Free Tier](https://aws.amazon.com/free/)
- **GCP**: [Free Trial](https://cloud.google.com/free) ($300 credit)
- **Azure**: [Free Account](https://azure.microsoft.com/free/) ($200 credit)

---

## Examples by Cloud Provider

### AWS (Recommended Start)

**Directory**: `examples/part-02-setup/aws/`

Most tutorial examples use AWS as the primary cloud. Start here if you're new to Terraform.

**Setup**:
1. Configure AWS credentials
2. Run `terraform init`
3. Run `terraform plan` (reads account info, creates nothing)

**[AWS Setup Guide](../../docs/setup-guides/aws-setup.md)** | **[AWS Example](aws/)**

---

### GCP (Google Cloud Platform)

**Directory**: `examples/part-02-setup/gcp/`

**Setup**:
1. Create GCP project
2. Enable APIs
3. Set up service account
4. Run examples

**[GCP Setup Guide](../../docs/setup-guides/gcp-setup.md)** | **[GCP Example](gcp/)**

---

### Azure (Microsoft Azure)

**Directory**: `examples/part-02-setup/azure/`

**Setup**:
1. Login via Azure CLI
2. Set subscription
3. Run examples

**[Azure Setup Guide](../../docs/setup-guides/azure-setup.md)** | **[Azure Example](azure/)**

---

## Quick Start (AWS Example)

```bash
# Navigate to AWS example
cd examples/part-02-setup/aws/

# Initialize Terraform (downloads AWS provider)
terraform init

# Validate configuration
terraform validate

# Preview (reads account info only, creates nothing)
terraform plan

# Apply (reads and outputs account info)
terraform apply

# Expected output:
# account_id = "123456789012"
# caller_arn = "arn:aws:iam::123456789012:user/your-user"
```

**Cost**: $0.00 (only reads account information)

---

## Key Concepts

### Provider

A provider is a plugin that interfaces with a specific cloud platform or service. Terraform downloads providers during `terraform init`.

**Example**:
```hcl
provider "aws" {
  region = "us-west-2"
}
```

### Required Providers Block

Declares which providers and versions your configuration needs:

```hcl
terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

**Version constraints**:
- `~> 5.0` - Any 5.x version (allows 5.1, 5.2, etc., but not 6.0)
- `>= 1.6.0` - At least version 1.6.0
- `= 1.6.0` - Exactly version 1.6.0 (not recommended, too strict)

### Provider Lock File

`.terraform.lock.hcl` records exact provider versions used. Commit this file to ensure team consistency.

### Authentication Methods

Each cloud has different authentication mechanisms:

**AWS**:
- Environment variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
- AWS CLI profile (`~/.aws/credentials`)
- IAM roles (for EC2, ECS, Lambda)

**GCP**:
- Service account JSON (`GOOGLE_APPLICATION_CREDENTIALS`)
- Application Default Credentials (`gcloud auth application-default login`)

**Azure**:
- Azure CLI (`az login`)
- Service principal (environment variables)
- Managed identity (for Azure VMs)

**See**: Detailed setup guides in `docs/setup-guides/`

---

## Learning Objectives

After completing Part 2, you should be able to:

- ✅ Install Terraform CLI on your operating system
- ✅ Configure cloud provider authentication
- ✅ Understand provider version constraints
- ✅ Initialize a Terraform project with `terraform init`
- ✅ Validate configuration with `terraform validate`
- ✅ Preview changes with `terraform plan`
- ✅ Troubleshoot authentication issues

## Self-Assessment Quiz

1. **What does `terraform init` do?**
   <details>
   <summary>Answer</summary>
   Downloads required provider plugins and initializes the working directory.
   </details>

2. **What's the difference between `source` and `version` in required_providers?**
   <details>
   <summary>Answer</summary>
   `source` specifies which provider to use (e.g., "hashicorp/aws"). `version` specifies which version constraint (e.g., "~> 5.0").
   </details>

3. **What does `~> 5.0` version constraint mean?**
   <details>
   <summary>Answer</summary>
   Allows any 5.x version (5.1, 5.2, etc.) but not 6.0. Ensures compatibility within major version.
   </details>

4. **Do these examples create any cloud resources?**
   <details>
   <summary>Answer</summary>
   No. They only read account/project information to validate authentication. Zero cost.
   </details>

---

## Troubleshooting

### "Error: No valid credential sources found"

**Cause**: Cloud provider credentials not configured

**Solution**:
- AWS: Run `aws configure` or set environment variables
- GCP: Set `GOOGLE_APPLICATION_CREDENTIALS` or run `gcloud auth application-default login`
- Azure: Run `az login`

**See**: [Troubleshooting Guide](../../docs/troubleshooting.md#authentication-problems)

### "Error: Unsupported Terraform Core version"

**Cause**: Terraform version too old

**Solution**:
```bash
# Check version
terraform version

# Upgrade Terraform
brew upgrade terraform  # macOS
# or download latest from https://developer.hashicorp.com/terraform/install
```

### "Error installing provider"

**Cause**: Network issues or provider not found

**Solution**:
```bash
# Clear provider cache and retry
rm -rf .terraform/
rm .terraform.lock.hcl
terraform init
```

---

## What's Next?

### Part 3: Your First Cloud Resource

Now that your providers are configured, Part 3 deploys your first real infrastructure:

- Create an EC2 instance on AWS
- Understand Terraform state
- Execute the full `init → plan → apply → destroy` lifecycle
- Troubleshoot common errors

**Continue to**: [Part 3: Your First Cloud Resource](../part-03-first-resource/) →

---

## Series Navigation

- [Part 1: Why Infrastructure as Code?](../part-01-iac-fundamentals/)
- **Part 2: Setting Up Terraform** ← You are here
- [Part 3: Your First Cloud Resource](../part-03-first-resource/)
- [Part 4: HCL Fundamentals](../part-04-hcl-fundamentals/)
- [All Parts](../../README.md#tutorial-series-overview)

---

**Questions?** Check the [Troubleshooting Guide](../../docs/troubleshooting.md) or [open an issue](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues).
