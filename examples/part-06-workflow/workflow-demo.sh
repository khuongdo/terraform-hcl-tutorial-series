#!/bin/bash
# Interactive Terraform Workflow Demonstration
# Part 6: Core Workflow

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored headers
print_header() {
    echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
}

# Function to wait for user
wait_for_user() {
    echo -e "\n${YELLOW}Press Enter to continue...${NC}"
    read -r
}

# Function to run command with explanation
run_command() {
    local description=$1
    local command=$2

    echo -e "${YELLOW}➜ $description${NC}"
    echo -e "${GREEN}Command: $command${NC}\n"

    eval "$command"

    wait_for_user
}

# Start demonstration
clear
echo -e "${GREEN}"
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║     Terraform Workflow Interactive Demonstration          ║
║     Part 6: Core Terraform CLI Workflow                   ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo "This script demonstrates the complete Terraform workflow:"
echo "  1. Initialize"
echo "  2. Format"
echo "  3. Validate"
echo "  4. Plan"
echo "  5. Apply"
echo "  6. State inspection"
echo "  7. Outputs"
echo "  8. Destroy"
echo ""
echo -e "${RED}WARNING: This will create real AWS resources!${NC}"
echo -e "${RED}Make sure you have AWS credentials configured.${NC}"
echo ""
wait_for_user

# Step 1: Initialize
print_header "Step 1: Initialize Terraform"
echo "Downloads provider plugins and prepares working directory."
run_command "Initialize Terraform" "terraform init"

# Step 2: Format
print_header "Step 2: Format Code"
echo "Formats all .tf files to canonical style."
run_command "Format Terraform files" "terraform fmt -recursive"

# Step 3: Validate
print_header "Step 3: Validate Configuration"
echo "Checks syntax and internal consistency (doesn't check credentials)."
run_command "Validate configuration" "terraform validate"

# Step 4: Plan
print_header "Step 4: Plan Changes"
echo "Preview what Terraform will create, update, or destroy."
run_command "Generate execution plan" "terraform plan"

# Step 5: Apply (with confirmation)
print_header "Step 5: Apply Changes"
echo "Creates/updates infrastructure based on configuration."
echo -e "${RED}This will create real AWS resources!${NC}"
echo ""
echo -e "${YELLOW}Do you want to proceed with terraform apply? (yes/no)${NC}"
read -r response

if [ "$response" = "yes" ]; then
    run_command "Apply configuration" "terraform apply -auto-approve"
else
    echo -e "${YELLOW}Skipping apply. Exiting demo.${NC}"
    exit 0
fi

# Step 6: State inspection
print_header "Step 6: Inspect State"
echo "View resources managed by Terraform."
run_command "List resources in state" "terraform state list"

echo -e "\n${YELLOW}Show details of S3 bucket:${NC}"
bucket_resource=$(terraform state list | grep aws_s3_bucket.example | head -n 1)
if [ -n "$bucket_resource" ]; then
    run_command "Show S3 bucket details" "terraform state show $bucket_resource"
fi

# Step 7: Outputs
print_header "Step 7: View Outputs"
echo "Retrieve output values from resources."
run_command "Show all outputs" "terraform output"

echo -e "\n${YELLOW}Get specific output (bucket name):${NC}"
run_command "Show bucket name" "terraform output bucket_name"

# Step 8: Workspace demonstration
print_header "Step 8: Workspace Management (Optional)"
echo "Workspaces allow multiple state files for same configuration."
echo -e "${YELLOW}Current workspace:${NC}"
terraform workspace show
echo ""
echo -e "${YELLOW}Available workspaces:${NC}"
terraform workspace list
wait_for_user

# Step 9: Plan file demonstration
print_header "Step 9: Plan File Workflow (Optional)"
echo "Save plan to file for review before apply."
run_command "Save plan to file" "terraform plan -out=tfplan"

echo -e "\n${YELLOW}View saved plan:${NC}"
run_command "Show plan file" "terraform show tfplan"

echo -e "\n${YELLOW}Cleaning up plan file...${NC}"
rm -f tfplan
echo "✅ Plan file removed"
wait_for_user

# Step 10: Destroy
print_header "Step 10: Destroy Resources"
echo -e "${RED}This will destroy all created resources!${NC}"
echo ""
echo -e "${YELLOW}Do you want to destroy the resources? (yes/no)${NC}"
read -r response

if [ "$response" = "yes" ]; then
    run_command "Destroy all resources" "terraform destroy -auto-approve"
    echo -e "\n${GREEN}✅ All resources destroyed successfully!${NC}"
else
    echo -e "${YELLOW}Skipping destroy.${NC}"
    echo -e "${RED}Remember to run 'terraform destroy' later to avoid charges!${NC}"
fi

# Summary
print_header "Workflow Demonstration Complete!"
echo -e "${GREEN}You've learned the core Terraform workflow:${NC}"
echo "  ✅ terraform init      - Initialize working directory"
echo "  ✅ terraform fmt       - Format code"
echo "  ✅ terraform validate  - Validate configuration"
echo "  ✅ terraform plan      - Preview changes"
echo "  ✅ terraform apply     - Create/update infrastructure"
echo "  ✅ terraform state     - Inspect state"
echo "  ✅ terraform output    - View outputs"
echo "  ✅ terraform destroy   - Remove infrastructure"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  • Explore state manipulation commands"
echo "  • Learn about workspaces for environments"
echo "  • Set up remote state (Part 9)"
echo "  • Create reusable modules (Part 7)"
echo ""
echo -e "${GREEN}Happy Terraforming! 🚀${NC}\n"
