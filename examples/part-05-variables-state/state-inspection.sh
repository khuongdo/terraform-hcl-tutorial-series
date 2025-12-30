#!/bin/bash
# State Inspection Helper Script
# Part 5: Variables, Outputs & State

set -e

echo "=== Terraform State Inspection ==="
echo ""

# Check if state file exists
if [ ! -f "terraform.tfstate" ]; then
    echo "❌ No terraform.tfstate file found."
    echo "Run 'terraform apply' first to create state."
    exit 1
fi

echo "✅ State file found"
echo ""

# List all resources in state
echo "📋 Resources in State:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
terraform state list
echo ""

# Show count of resources
echo "📊 Resource Count:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
terraform state list | wc -l | xargs echo "Total resources:"
echo ""

# Show outputs
echo "📤 Outputs:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
terraform output
echo ""

# Show specific resource details if provided
if [ $# -eq 1 ]; then
    echo "🔍 Detailed View of Resource: $1"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    terraform state show "$1"
    echo ""
fi

echo "💡 Usage Tips:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  View specific resource:      ./state-inspection.sh aws_instance.web[0]"
echo "  List all resources:          terraform state list"
echo "  Show resource details:       terraform state show <resource>"
echo "  Pull remote state:           terraform state pull > state.json"
echo "  Move resource:               terraform state mv <src> <dest>"
echo "  Remove from state:           terraform state rm <resource>"
echo ""

echo "✨ State inspection complete!"
