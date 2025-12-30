# Part 11: Security & Secrets Management

Secure secrets handling with Vault and SOPS encryption.

## What You'll Learn
- HashiCorp Vault integration
- SOPS file encryption
- Sensitive data handling
- Secret rotation patterns
- Least privilege IAM

## Tools

### HashiCorp Vault
Centralized secrets management.

### SOPS
Encrypted file storage for secrets.

### AWS Secrets Manager
Cloud-native secrets storage.

## Examples

### Vault Provider
```hcl
provider "vault" {
  address = "https://vault.example.com"
}

data "vault_generic_secret" "db_password" {
  path = "secret/database/password"
}

resource "aws_db_instance" "main" {
  password = data.vault_generic_secret.db_password.data["password"]
}
```

### SOPS Encrypted Files
```bash
# Encrypt secrets file
sops --encrypt secrets.yaml > secrets.enc.yaml

# Decrypt in Terraform
data "sops_file" "secrets" {
  source_file = "secrets.enc.yaml"
}
```

## Best Practices

- ✅ Never hardcode secrets
- ✅ Use secret management tools
- ✅ Rotate secrets regularly
- ✅ Encrypt state files
- ✅ Use IAM roles over keys
- ❌ Don't commit secrets to Git
- ❌ Don't log sensitive values

## References
- [Vault Provider](https://registry.terraform.io/providers/hashicorp/vault/)
- [SOPS](https://github.com/mozilla/sops)
