#!/bin/bash
# Terraform Import Example
# Part 6: Workflow - Importing Existing Resources

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Terraform Import Example${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"

echo "This script demonstrates how to import existing AWS resources into Terraform."
echo ""
echo "Scenario: You created an S3 bucket manually in AWS Console."
echo "Goal: Bring it under Terraform management without recreating it."
echo ""

# Check if bucket name provided
if [ $# -eq 0 ]; then
    echo -e "${YELLOW}Usage: $0 <existing-bucket-name>${NC}"
    echo ""
    echo "Example:"
    echo "  $0 my-existing-bucket-name"
    echo ""
    echo "Steps to test this:"
    echo "  1. Create bucket manually: aws s3 mb s3://my-test-bucket-12345"
    echo "  2. Run this script: $0 my-test-bucket-12345"
    exit 1
fi

BUCKET_NAME=$1

echo -e "${GREEN}Step 1: Verify bucket exists in AWS${NC}"
echo "Checking if bucket '$BUCKET_NAME' exists..."

if aws s3api head-bucket --bucket "$BUCKET_NAME" 2>/dev/null; then
    echo -e "✅ Bucket exists in AWS\n"
else
    echo -e "${YELLOW}❌ Bucket does not exist or you don't have access${NC}"
    echo "Create it first with: aws s3 mb s3://$BUCKET_NAME"
    exit 1
fi

echo -e "${GREEN}Step 2: Create Terraform configuration${NC}"
cat > import-bucket.tf << EOF
# Imported S3 bucket
resource "aws_s3_bucket" "imported" {
  bucket = "$BUCKET_NAME"

  tags = {
    ManagedBy = "terraform"
    Imported  = "true"
  }
}
EOF
echo "✅ Created import-bucket.tf"
cat import-bucket.tf
echo ""

echo -e "${GREEN}Step 3: Initialize Terraform${NC}"
terraform init
echo ""

echo -e "${GREEN}Step 4: Import bucket into Terraform state${NC}"
echo "Running: terraform import aws_s3_bucket.imported $BUCKET_NAME"
terraform import aws_s3_bucket.imported "$BUCKET_NAME"
echo ""

echo -e "${GREEN}Step 5: Verify import${NC}"
echo "Resource in state:"
terraform state show aws_s3_bucket.imported
echo ""

echo -e "${GREEN}Step 6: Check for drift${NC}"
echo "Running terraform plan to see differences..."
terraform plan
echo ""

echo -e "${YELLOW}Note: You may see planned changes for:${NC}"
echo "  • Tags that don't exist on the actual bucket"
echo "  • Default values Terraform wants to set"
echo ""
echo "To fix: Update import-bucket.tf to match actual bucket configuration,"
echo "then run 'terraform plan' again until it shows no changes."
echo ""

echo -e "${GREEN}Step 7: Cleanup (optional)${NC}"
echo -e "${YELLOW}To remove the imported resource from Terraform management:${NC}"
echo "  terraform state rm aws_s3_bucket.imported"
echo "  rm import-bucket.tf"
echo ""
echo -e "${YELLOW}To delete the bucket entirely:${NC}"
echo "  terraform destroy -target=aws_s3_bucket.imported"
echo ""

echo -e "${GREEN}✅ Import complete!${NC}"
echo ""
echo "Next steps:"
echo "  1. Update import-bucket.tf to match actual configuration"
echo "  2. Run 'terraform plan' to verify no changes"
echo "  3. Manage bucket with Terraform going forward"
