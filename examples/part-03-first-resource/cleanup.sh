#!/bin/bash
# Cleanup script for Part 3 - First Resource
# Destroys EC2 instance created by this example

set -e

echo "========================================="
echo "Part 3: Cleanup EC2 Instance"
echo "========================================="
echo ""

# Check if Terraform is initialized
if [ ! -d ".terraform" ]; then
    echo "❌ Error: Terraform not initialized"
    echo "Run 'terraform init' first"
    exit 1
fi

# Show what will be destroyed
echo "📋 Resources to destroy:"
terraform show -no-color | grep -A5 "aws_instance.web" || echo "No resources found"
echo ""

# Confirm destruction
read -p "⚠️  Destroy EC2 instance? This cannot be undone. [yes/no]: " confirm

if [ "$confirm" != "yes" ]; then
    echo "❌ Aborted"
    exit 0
fi

echo ""
echo "🗑️  Destroying resources..."
terraform destroy -auto-approve

echo ""
echo "✅ Cleanup complete!"
echo ""
echo "Verify in AWS Console:"
echo "https://console.aws.amazon.com/ec2/v2/home?region=us-west-2#Instances:"
