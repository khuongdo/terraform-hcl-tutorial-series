# GCP Provider Setup

Validate Google Cloud Platform authentication and provider configuration.

**Cost**: $0.00 (reads project information only, creates no resources)

---

## Prerequisites

1. **GCP Account**: [Start free trial](https://cloud.google.com/free) ($300 credit)
2. **GCP Project**: [Create project](https://console.cloud.google.com/projectcreate)
3. **gcloud SDK**: [Installation guide](https://cloud.google.com/sdk/docs/install)
4. **Terraform Installed**: [Installation guide](https://developer.hashicorp.com/terraform/install)

---

## GCP Setup

### 1. Create GCP Project

```bash
# Via gcloud CLI
gcloud projects create my-terraform-project --name="My Terraform Project"

# Set as default project
gcloud config set project my-terraform-project

# Or use existing project
gcloud config set project YOUR_EXISTING_PROJECT_ID
```

**Via Console**: https://console.cloud.google.com/projectcreate

### 2. Enable Required APIs

```bash
# Enable Compute Engine API (required for most examples)
gcloud services enable compute.googleapis.com

# Verify enabled services
gcloud services list --enabled
```

### 3. Authentication Setup

Choose one method:

#### Option 1: Application Default Credentials (Recommended for Local)

```bash
gcloud auth application-default login

# This creates credentials at:
# ~/.config/gcloud/application_default_credentials.json
```

#### Option 2: Service Account (Recommended for CI/CD)

```bash
# Create service account
gcloud iam service-accounts create terraform \
  --display-name="Terraform Service Account"

# Grant permissions
gcloud projects add-iam-policy-binding my-terraform-project \
  --member="serviceAccount:terraform@my-terraform-project.iam.gserviceaccount.com" \
  --role="roles/viewer"

# Create and download key
gcloud iam service-accounts keys create ~/terraform-key.json \
  --iam-account=terraform@my-terraform-project.iam.gserviceaccount.com

# Set environment variable
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/terraform-key.json"
```

**Verify authentication**:
```bash
gcloud auth list
gcloud config list project
```

---

## Usage

### 1. Configure Project ID

```bash
cd examples/part-02-setup/gcp/

# Copy example config
cp terraform.tfvars.example terraform.tfvars

# Edit terraform.tfvars and set your project ID
# gcp_project_id = "your-actual-project-id"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Plan and Apply

```bash
terraform plan
terraform apply
```

**Expected output**:
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

project_id = "my-terraform-project"
project_number = "123456789012"
project_name = "My Terraform Project"
current_region = "us-central1"
available_zones = ["us-central1-a", "us-central1-b", "us-central1-c", "us-central1-f"]
zones_count = 4
```

---

## Troubleshooting

### Error: "google: could not find default credentials"

**Solutions**:
1. Run `gcloud auth application-default login`
2. Set `GOOGLE_APPLICATION_CREDENTIALS` environment variable
3. Verify: `echo $GOOGLE_APPLICATION_CREDENTIALS`

### Error: "project not found or permission denied"

**Solutions**:
1. Verify project ID: `gcloud config get-value project`
2. Ensure project exists: `gcloud projects list`
3. Check permissions: Service account needs at least `roles/viewer`

### Error: "API has not been used in project before"

**Solution**:
```bash
gcloud services enable compute.googleapis.com
```

---

## Next Steps

✅ GCP authentication working
✅ Terraform provider configured

**Continue to**:
- [Azure Setup](../azure/) - Configure Azure provider
- [Part 3: Your First Cloud Resource](../../part-03-first-resource/)

---

## Resources

- [GCP Provider Documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GCP Free Tier](https://cloud.google.com/free)
- [GCP IAM Best Practices](https://cloud.google.com/iam/docs/best-practices)
