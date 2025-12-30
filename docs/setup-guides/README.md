# Cloud Provider Setup Guides

This directory contains authentication and configuration guides for each cloud provider used in the tutorial series.

## Available Guides

- **[AWS Setup](aws-setup.md)** - Amazon Web Services configuration
- **[GCP Setup](gcp-setup.md)** - Google Cloud Platform configuration
- **[Azure Setup](azure-setup.md)** - Microsoft Azure configuration

## Quick Start

Choose the cloud provider you want to work with:

### AWS (Recommended for Parts 1-7)
Most tutorial examples use AWS as the primary cloud provider. Start here if you're new to Terraform.

**Prerequisites**:
- AWS account
- AWS CLI installed
- IAM user with appropriate permissions

**Get Started**: [AWS Setup Guide](aws-setup.md)

### GCP (Introduced in Part 8)
Google Cloud Platform examples start in Part 8 (Multi-Cloud Patterns).

**Prerequisites**:
- GCP account
- gcloud CLI installed
- Service account with appropriate permissions

**Get Started**: [GCP Setup Guide](gcp-setup.md)

### Azure (Introduced in Part 8)
Microsoft Azure examples start in Part 8 (Multi-Cloud Patterns).

**Prerequisites**:
- Azure account
- Azure CLI installed
- Service principal or managed identity

**Get Started**: [Azure Setup Guide](azure-setup.md)

## Multi-Cloud Setup

For Part 8 and beyond, you'll need all three cloud providers configured. Follow each guide in sequence:

1. AWS Setup (primary)
2. GCP Setup
3. Azure Setup

## Troubleshooting

If you encounter authentication issues, see:
- [Troubleshooting Guide](../troubleshooting.md)
- Individual provider troubleshooting sections in each setup guide

## Cost Management

⚠️ **Setting up cloud accounts may incur costs**

- Use free tier resources when possible
- Set up billing alerts
- Review cost calculators before deploying
- Always run `terraform destroy` when done

**Billing Dashboards**:
- AWS: https://console.aws.amazon.com/billing/
- GCP: https://console.cloud.google.com/billing
- Azure: https://portal.azure.com/#blade/Microsoft_Azure_Billing

## Security Best Practices

### Never Commit Credentials
- Use `.gitignore` to exclude credential files
- Store secrets in environment variables or secret managers
- Rotate credentials regularly

### Use Least Privilege
- Create separate IAM users/service accounts for Terraform
- Grant only required permissions
- Use managed policies when possible

### Enable MFA
- Enable multi-factor authentication on cloud accounts
- Use MFA for IAM users with admin access

## Next Steps

After completing authentication setup:
1. Test provider connectivity (Part 2 examples)
2. Deploy your first resource (Part 3)
3. Follow the tutorial series in order

---

**Questions?** Check [Troubleshooting](../troubleshooting.md) or [open an issue](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues).
