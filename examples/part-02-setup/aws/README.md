# AWS Provider Setup

Validate AWS authentication and provider configuration.

**Cost**: $0.00 (reads account information only, creates no resources)

---

## Prerequisites

1. **AWS Account**: [Sign up for free tier](https://aws.amazon.com/free/)
2. **AWS CLI Installed**: [Installation guide](https://aws.amazon.com/cli/)
3. **Terraform Installed**: [Installation guide](https://developer.hashicorp.com/terraform/install)

---

## AWS Authentication Setup

Choose one of these methods:

### Option 1: Environment Variables (Recommended for CI/CD)

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-west-2"
```

### Option 2: AWS CLI Profile (Recommended for Local Development)

```bash
# Configure AWS CLI (interactive)
aws configure

# This creates ~/.aws/credentials with:
# [default]
# aws_access_key_id = your-access-key-id
# aws_secret_access_key = your-secret-access-key
```

**Verify authentication**:
```bash
aws sts get-caller-identity

# Expected output:
# {
#     "UserId": "AIDACKCEVSQ6C2EXAMPLE",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/terraform-user"
# }
```

### Option 3: IAM Roles (For EC2, ECS, Lambda)

When running Terraform on AWS compute (EC2 instance, ECS task, Lambda function), Terraform automatically uses the instance's IAM role. No explicit credentials needed.

**See**: [Detailed AWS setup guide](../../../docs/setup-guides/aws-setup.md)

---

## Usage

### 1. Initialize Terraform

```bash
cd examples/part-02-setup/aws/

terraform init
```

**What this does**:
- Downloads AWS provider plugin (~100MB)
- Creates `.terraform/` directory
- Generates `.terraform.lock.hcl` (provider version lock file)

**Expected output**:
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.32.0...
- Installed hashicorp/aws v5.32.0

Terraform has been successfully initialized!
```

### 2. Validate Configuration

```bash
terraform validate
```

**Expected output**:
```
Success! The configuration is valid.
```

### 3. Preview (Plan)

```bash
terraform plan
```

**What this does**:
- Authenticates to AWS
- Reads account information (via data sources)
- Shows what Terraform will do (in this case, just read data)

**Expected output**:
```
data.aws_caller_identity.current: Reading...
data.aws_region.current: Reading...
data.aws_regions.available: Reading...

No changes. Your infrastructure matches the configuration.
```

### 4. Apply (Execute)

```bash
terraform apply
```

**Type "yes" when prompted**

**Expected output**:
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

account_id = "123456789012"
caller_arn = "arn:aws:iam::123456789012:user/terraform-user"
caller_user = "AIDACKCEVSQ6C2EXAMPLE"
current_region = "us-west-2"
region_endpoint = "ec2.us-west-2.amazonaws.com"
available_regions_count = 28
```

**✅ Success!** If you see this output, your AWS authentication is working correctly.

---

## What Did This Example Do?

**Data Sources Used**:
- `aws_caller_identity` - Read your AWS account ID and user ARN
- `aws_region` - Read current region information
- `aws_regions` - List all available AWS regions

**Resources Created**: None (zero cost)

**State File**: `terraform.tfstate` created (stores data source outputs)

---

## Customization

### Change AWS Region

Edit `main.tf` or pass via command line:

```bash
# Via command line
terraform apply -var="aws_region=us-east-1"

# Or create terraform.tfvars file
echo 'aws_region = "us-east-1"' > terraform.tfvars
terraform apply
```

### Use Different AWS Profile

```bash
# Use specific AWS CLI profile
export AWS_PROFILE="my-profile"
terraform apply

# Or in provider config (add to main.tf):
provider "aws" {
  region  = "us-west-2"
  profile = "my-profile"
}
```

---

## Troubleshooting

### Error: "No valid credential sources found"

**Cause**: AWS credentials not configured

**Solutions**:
1. Check environment variables: `echo $AWS_ACCESS_KEY_ID`
2. Check AWS CLI config: `cat ~/.aws/credentials`
3. Verify AWS CLI works: `aws sts get-caller-identity`
4. Ensure IAM user has required permissions

### Error: "operation error STS: GetCallerIdentity"

**Cause**: Network connectivity or invalid credentials

**Solutions**:
1. Check internet connectivity: `curl -I https://sts.amazonaws.com`
2. Verify credentials are valid (not expired)
3. Check IAM user exists and has permissions
4. Try different AWS region

### Error: "Error acquiring the state lock"

**Cause**: Terraform process didn't finish cleanly

**Solution**:
```bash
# Force unlock (use with caution)
terraform force-unlock LOCK_ID

# Or simply wait - local state lock timeout is short
```

### Permission Denied Errors

**Cause**: IAM user lacks required permissions

**Solution**: Ensure IAM user/role has at least these permissions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "sts:GetCallerIdentity",
        "ec2:DescribeRegions"
      ],
      "Resource": "*"
    }
  ]
}
```

---

## Understanding the Files

### main.tf

Contains:
- `terraform {}` block - Version constraints and required providers
- `provider "aws"` - AWS provider configuration
- `variable` - Input parameters
- `data` sources - Read-only AWS information
- `output` - Display values

### .terraform/

Created by `terraform init`. Contains:
- Downloaded provider plugins
- Provider cache

**Don't commit to Git** (excluded by `.gitignore`)

### .terraform.lock.hcl

Records exact provider versions used. **Commit this file** to ensure team uses same versions.

### terraform.tfstate

Records current state (data source outputs). For this example, contains no resources.

**Don't commit to Git** for real projects (may contain sensitive data)

---

## Cleanup

This example creates no resources, but to remove state file:

```bash
rm terraform.tfstate
rm terraform.tfstate.backup
rm -rf .terraform/
```

**Note**: No `terraform destroy` needed (nothing to destroy)

---

## Next Steps

✅ AWS authentication working
✅ Terraform provider configured
✅ First `terraform init` / `plan` / `apply` complete

**Continue to**:
- [GCP Setup](../gcp/) - Configure Google Cloud provider
- [Azure Setup](../azure/) - Configure Azure provider
- [Part 3: Your First Cloud Resource](../../part-03-first-resource/) - Deploy actual infrastructure

---

## Additional Resources

- [AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS Free Tier](https://aws.amazon.com/free/)
- [AWS IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
- [Terraform AWS Examples](https://github.com/hashicorp/terraform-provider-aws/tree/main/examples)
