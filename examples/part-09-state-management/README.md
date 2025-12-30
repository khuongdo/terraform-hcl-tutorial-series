# Part 9: State Management

Configure remote state backends for team collaboration and state locking.

## What You'll Learn
- Remote state backends (S3, GCS, Azure Blob)
- State locking with DynamoDB
- State encryption at rest
- State migration between backends
- Team workflow best practices

## Prerequisites
- Cloud accounts configured
- Terraform 1.6+ installed
- Understanding of state from Part 5-6

## Remote Backends

### AWS S3 + DynamoDB
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
```

### GCP Cloud Storage
```hcl
terraform {
  backend "gcs" {
    bucket = "my-terraform-state"
    prefix = "prod"
  }
}
```

### Azure Blob Storage
```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
```

## State Migration

```bash
# 1. Add backend configuration
# 2. Run init with migration
terraform init -migrate-state

# 3. Confirm migration
# 4. Delete local state file
rm terraform.tfstate*
```

## Best Practices

- ✅ Always use remote backends for teams
- ✅ Enable encryption at rest
- ✅ Enable state locking
- ✅ Use separate state files per environment
- ✅ Restrict state file access (IAM)
- ❌ Never commit state files to Git
- ❌ Don't manually edit state files

## References
- [Backend Types](https://developer.hashicorp.com/terraform/language/settings/backends)
- [State Locking](https://developer.hashicorp.com/terraform/language/state/locking)
