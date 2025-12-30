# Part 3: Your First Cloud Resource

Deploy a simple EC2 instance to learn Terraform workflow.

**Cost**: ~$0.01/hour for t2.micro (free tier eligible: 750 hours/month)

---

## What You'll Learn

- Create real cloud resources with Terraform
- Understand plan → apply → destroy lifecycle
- Inspect Terraform state file
- Use data sources to find AMIs
- Troubleshoot common errors

---

## Prerequisites

- AWS account configured (see [Part 2](../part-02-setup/aws/))
- AWS credentials set up
- Terraform 1.6+ installed

---

## Usage

### 1. Initialize Terraform

```bash
cd examples/part-03-first-resource/

terraform init
```

This downloads the AWS provider plugin.

### 2. Preview Changes

```bash
terraform plan
```

**What this does**:
- Finds latest Amazon Linux 2023 AMI (via data source)
- Shows EC2 instance that will be created
- Displays estimated cost (if available)

**Expected output**:
```
Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                          = "ami-0abcdef1234567890"
      + instance_type                = "t2.micro"
      + tags                         = {
          + "Name" = "my-first-terraform-instance"
        }
      ...
    }

Plan: 1 to add, 0 to change, 0 to destroy.
```

### 3. Create Resources

```bash
terraform apply
```

**Type "yes" when prompted**

**Expected output**:
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-0abcdef1234567890"
instance_public_ip = "54.123.45.67"
instance_state = "running"
ami_id = "ami-0abcdef1234567890"
```

### 4. Inspect State

```bash
# View all state
terraform show

# View specific resource
terraform state show aws_instance.web

# List resources
terraform state list
```

### 5. Cleanup (IMPORTANT!)

```bash
# Option 1: Use terraform destroy
terraform destroy

# Option 2: Use cleanup script
chmod +x cleanup.sh
./cleanup.sh
```

**⚠️ Always destroy resources to avoid AWS charges.**

---

## Cost Warning

**This creates real AWS resources that may incur charges:**

- t2.micro is free tier eligible (750 hours/month for first 12 months)
- After free tier: ~$0.0116/hour or ~$8.50/month
- **Always run `terraform destroy` when done**
- Check [AWS EC2 Pricing](https://aws.amazon.com/ec2/pricing/)

---

## What Did This Example Create?

**Resources**:
- 1× EC2 instance (t2.micro, Amazon Linux 2023)
- Default VPC and security group (if not exists)
- No SSH key (instance not accessible, intentional for simplicity)

**State File**:
- `terraform.tfstate` created (contains instance metadata)
- **Never commit to Git** (may contain sensitive data)

---

## Troubleshooting

### Error: "Error launching source instance"

**Cause**: Authentication or permissions issue

**Solutions**:
1. Check AWS credentials: `aws sts get-caller-identity`
2. Verify IAM user has `ec2:RunInstances` permission
3. Ensure correct AWS region (us-west-2)

### Error: "InvalidAMIID.NotFound"

**Cause**: AMI not available in your region

**Solution**: The data source automatically finds the latest Amazon Linux AMI. If error persists:
```bash
# Verify AMI exists
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023.*-x86_64" \
  --region us-west-2
```

### Error: "Error acquiring the state lock"

**Cause**: Previous Terraform operation didn't complete cleanly

**Solution**:
```bash
# Wait a few seconds, then retry
# Or force unlock (use with caution)
terraform force-unlock LOCK_ID
```

### Instance Shows "pending" State

**Cause**: EC2 instance is still starting (normal)

**Solution**: Wait 30-60 seconds, then check:
```bash
terraform refresh
terraform output instance_state
```

---

## Understanding the Code

### Data Source vs Resource

```hcl
# Data source - READS existing infrastructure
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  ...
}

# Resource - CREATES new infrastructure
resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux_2023.id
  ...
}
```

### Why Use Data Source for AMI?

AMI IDs change frequently and vary by region. Using a data source:
- Automatically finds latest AMI
- Works across all regions
- Ensures security patches are included

**Alternative (hardcoded AMI)**:
```hcl
resource "aws_instance" "web" {
  ami = "ami-0abcdef1234567890"  # ❌ Brittle, region-specific
  ...
}
```

---

## Next Steps

✅ Created first cloud resource
✅ Learned Terraform workflow
✅ Inspected state file

**Continue to**:
- [Part 4: HCL Fundamentals](../part-04-hcl-fundamentals/) - Syntax deep dive
- [Part 5: Variables and State](../part-05-variables-state/) - Parameterization

---

## Additional Resources

- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Terraform AWS Provider - EC2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Data Source: aws_ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami)
