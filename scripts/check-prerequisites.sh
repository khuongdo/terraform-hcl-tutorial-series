#!/usr/bin/env bash
# Check prerequisites for Terraform HCL Tutorial Series
# Usage: ./scripts/check-prerequisites.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "========================================="
echo "Terraform HCL Tutorial Series"
echo "Prerequisites Check"
echo "========================================="
echo ""

# Track overall status
all_good=true

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check version
check_version() {
    local tool=$1
    local required=$2
    local current=$3

    echo -n "Checking $tool version... "
    if [[ "$current" == "unknown" ]]; then
        echo -e "${YELLOW}WARNING${NC}: Could not determine version"
        return 0
    fi

    echo -e "${GREEN}$current${NC}"
}

# Check Terraform
echo "=== Core Tools ==="
if command_exists terraform; then
    version=$(terraform version -json 2>/dev/null | grep -o '"terraform_version":"[^"]*' | cut -d'"' -f4 || echo "unknown")
    check_version "Terraform" "1.6.0+" "$version"
else
    echo -e "${RED}✗${NC} Terraform not found"
    echo "  Install: https://developer.hashicorp.com/terraform/install"
    all_good=false
fi
echo ""

# Check Git
echo "=== Version Control ==="
if command_exists git; then
    version=$(git --version | awk '{print $3}')
    check_version "Git" "2.0+" "$version"
else
    echo -e "${RED}✗${NC} Git not found"
    echo "  Install: https://git-scm.com/downloads"
    all_good=false
fi
echo ""

# Check Cloud CLIs
echo "=== Cloud Provider CLIs (Optional) ==="

# AWS CLI
if command_exists aws; then
    version=$(aws --version 2>&1 | awk '{print $1}' | cut -d'/' -f2)
    check_version "AWS CLI" "2.0+" "$version"
else
    echo -e "${YELLOW}○${NC} AWS CLI not found (required for AWS examples)"
    echo "  Install: https://aws.amazon.com/cli/"
fi

# Google Cloud SDK
if command_exists gcloud; then
    version=$(gcloud version --format="value(version)" 2>/dev/null || echo "unknown")
    check_version "gcloud" "Latest" "$version"
else
    echo -e "${YELLOW}○${NC} gcloud not found (required for GCP examples)"
    echo "  Install: https://cloud.google.com/sdk/docs/install"
fi

# Azure CLI
if command_exists az; then
    version=$(az version --output json 2>/dev/null | grep -o '"azure-cli": "[^"]*' | cut -d'"' -f4 || echo "unknown")
    check_version "Azure CLI" "2.0+" "$version"
else
    echo -e "${YELLOW}○${NC} Azure CLI not found (required for Azure examples)"
    echo "  Install: https://learn.microsoft.com/cli/azure/install-azure-cli"
fi
echo ""

# Check Go (for Terratest)
echo "=== Testing Tools (Optional) ==="
if command_exists go; then
    version=$(go version | awk '{print $3}' | sed 's/go//')
    check_version "Go" "1.21+" "$version"
else
    echo -e "${YELLOW}○${NC} Go not found (required for Part 10: Terratest)"
    echo "  Install: https://go.dev/doc/install"
fi

# Check tfsec
if command_exists tfsec; then
    version=$(tfsec --version 2>&1 | grep -o 'v[0-9.]*' || echo "unknown")
    check_version "tfsec" "Latest" "$version"
else
    echo -e "${YELLOW}○${NC} tfsec not found (recommended for security scanning)"
    echo "  Install: https://github.com/aquasecurity/tfsec#installation"
fi
echo ""

# Check authentication status
echo "=== Authentication Status ==="

# AWS
if command_exists aws; then
    if aws sts get-caller-identity >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} AWS credentials configured"
    else
        echo -e "${YELLOW}○${NC} AWS credentials not configured"
        echo "  See: docs/setup-guides/aws-setup.md"
    fi
else
    echo -e "${YELLOW}○${NC} AWS CLI not installed"
fi

# GCP
if command_exists gcloud; then
    if gcloud auth list --filter=status:ACTIVE --format="value(account)" >/dev/null 2>&1; then
        account=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null | head -1)
        if [[ -n "$account" ]]; then
            echo -e "${GREEN}✓${NC} GCP authenticated ($account)"
        else
            echo -e "${YELLOW}○${NC} GCP not authenticated"
            echo "  Run: gcloud auth login"
        fi
    else
        echo -e "${YELLOW}○${NC} GCP not authenticated"
        echo "  See: docs/setup-guides/gcp-setup.md"
    fi
else
    echo -e "${YELLOW}○${NC} gcloud not installed"
fi

# Azure
if command_exists az; then
    if az account show >/dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Azure credentials configured"
    else
        echo -e "${YELLOW}○${NC} Azure not authenticated"
        echo "  Run: az login"
        echo "  See: docs/setup-guides/azure-setup.md"
    fi
else
    echo -e "${YELLOW}○${NC} Azure CLI not installed"
fi
echo ""

# Summary
echo "========================================="
if $all_good; then
    echo -e "${GREEN}✓ All required tools installed!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Configure cloud provider authentication (see docs/setup-guides/)"
    echo "2. Start with Part 2: examples/part-02-setup/"
    echo "3. Follow the tutorial series at: https://khuongdo.dev"
else
    echo -e "${RED}✗ Some required tools are missing${NC}"
    echo ""
    echo "Install missing tools and run this script again."
fi
echo "========================================="
echo ""

exit 0
