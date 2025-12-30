# Azure Provider Setup

Validate Azure authentication and provider configuration.

**Cost**: $0.00 (reads subscription information only, creates no resources)

---

## Prerequisites

1. **Azure Account**: [Create free account](https://azure.microsoft.com/free/) ($200 credit for 30 days)
2. **Azure CLI Installed**: [Installation guide](https://learn.microsoft.com/cli/azure/install-azure-cli)
3. **Terraform Installed**: [Installation guide](https://developer.hashicorp.com/terraform/install)

---

## Azure Authentication Setup

Choose one of these methods:

### Option 1: Azure CLI (Recommended for Local Development)

```bash
# Login to Azure
az login

# This opens browser for authentication
# Upon success, displays available subscriptions

# Set default subscription (if you have multiple)
az account set --subscription "My Subscription Name"

# Or use subscription ID
az account set --subscription "12345678-1234-1234-1234-123456789012"
```

**Verify authentication**:
```bash
az account show

# Expected output:
# {
#   "id": "12345678-1234-1234-1234-123456789012",
#   "name": "My Azure Subscription",
#   "tenantId": "87654321-4321-4321-4321-210987654321",
#   "state": "Enabled"
# }
```

### Option 2: Service Principal (Recommended for CI/CD)

```bash
# Create service principal
az ad sp create-for-rbac --name terraform-sp \
  --role Contributor \
  --scopes /subscriptions/YOUR_SUBSCRIPTION_ID

# Expected output:
# {
#   "appId": "abcdef12-3456-7890-abcd-ef1234567890",
#   "displayName": "terraform-sp",
#   "password": "your-generated-password",
#   "tenant": "87654321-4321-4321-4321-210987654321"
# }

# Set environment variables
export ARM_CLIENT_ID="abcdef12-3456-7890-abcd-ef1234567890"
export ARM_CLIENT_SECRET="your-generated-password"
export ARM_SUBSCRIPTION_ID="12345678-1234-1234-1234-123456789012"
export ARM_TENANT_ID="87654321-4321-4321-4321-210987654321"
```

**Security Note**: Store service principal credentials securely. Never commit them to Git.

### Option 3: Managed Identity (For Azure VMs)

When running Terraform on Azure compute (VM, Container Instance, App Service), Terraform automatically uses the VM's Managed Identity. No explicit credentials needed.

**See**: [Detailed Azure setup guide](../../../docs/setup-guides/azure-setup.md)

---

## Usage

### 1. Initialize Terraform

```bash
cd examples/part-02-setup/azure/

terraform init
```

**What this does**:
- Downloads Azure provider plugin (~150MB)
- Creates `.terraform/` directory
- Generates `.terraform.lock.hcl` (provider version lock file)

**Expected output**:
```
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "~> 3.0"...
- Installing hashicorp/azurerm v3.85.0...
- Installed hashicorp/azurerm v3.85.0

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
- Authenticates to Azure
- Reads subscription information (via data sources)
- Shows what Terraform will do (in this case, just read data)

**Expected output**:
```
data.azurerm_client_config.current: Reading...
data.azurerm_subscription.current: Reading...
data.azurerm_locations.available: Reading...

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

subscription_id = "12345678-1234-1234-1234-123456789012"
subscription_name = "My Azure Subscription"
tenant_id = "87654321-4321-4321-4321-210987654321"
client_id = "abcdef12-3456-7890-abcd-ef1234567890"
available_locations = ["eastus", "eastus2", "westus", "westus2", ...]
locations_count = 60
```

**✅ Success!** If you see this output, your Azure authentication is working correctly.

---

## What Did This Example Do?

**Data Sources Used**:
- `azurerm_client_config` - Read your Azure client/tenant information
- `azurerm_subscription` - Read current subscription details
- `azurerm_locations` - List all available Azure regions

**Resources Created**: None (zero cost)

**State File**: `terraform.tfstate` created (stores data source outputs)

---

## Troubleshooting

### Error: "Please run 'az login' to setup account"

**Cause**: Not authenticated via Azure CLI

**Solutions**:
1. Run `az login` and complete browser authentication
2. Verify login: `az account show`
3. Check subscription: `az account list --output table`

### Error: "Service principal not found in tenant"

**Cause**: Service principal credentials incorrect or expired

**Solutions**:
1. Verify environment variables:
   ```bash
   echo $ARM_CLIENT_ID
   echo $ARM_TENANT_ID
   echo $ARM_SUBSCRIPTION_ID
   ```
2. Recreate service principal if credentials are lost
3. Check service principal exists: `az ad sp list --display-name terraform-sp`

### Error: "subscription not found or access denied"

**Cause**: Insufficient permissions or wrong subscription

**Solutions**:
1. List subscriptions: `az account list --output table`
2. Set correct subscription: `az account set --subscription "NAME"`
3. Verify permissions: Service principal needs at least `Reader` role

### Error: "Provider configuration is invalid"

**Cause**: Missing `features {}` block in provider configuration

**Solution**: Ensure provider block includes:
```hcl
provider "azurerm" {
  features {}
}
```

---

## Understanding the Files

### main.tf

Contains:
- `terraform {}` block - Version constraints and required providers
- `provider "azurerm"` - Azure provider configuration with required `features {}` block
- `data` sources - Read-only Azure information
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

✅ Azure authentication working
✅ Terraform provider configured
✅ First `terraform init` / `plan` / `apply` complete

**Continue to**:
- [AWS Setup](../aws/) - Configure AWS provider
- [GCP Setup](../gcp/) - Configure Google Cloud provider
- [Part 3: Your First Cloud Resource](../../part-03-first-resource/) - Deploy actual infrastructure

---

## Additional Resources

- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Free Account](https://azure.microsoft.com/free/)
- [Azure CLI Reference](https://learn.microsoft.com/cli/azure/)
- [Service Principal Authentication](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)
