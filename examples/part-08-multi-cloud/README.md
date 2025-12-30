# Part 8: Multi-Cloud Patterns

Deploy identical infrastructure across AWS, GCP, and Azure using Terraform.

## What You'll Learn
- Multi-cloud provider configuration
- Cross-cloud resource equivalents
- Provider aliasing patterns
- Cloud-agnostic module design
- Disaster recovery across clouds

## Prerequisites
- AWS, GCP, and Azure accounts configured
- Terraform 1.6+ installed
- Understanding of Parts 1-7

## Cloud Resource Equivalents

| Service | AWS | GCP | Azure |
|---------|-----|-----|-------|
| Compute | EC2 | Compute Engine | Virtual Machines |
| Storage | S3 | Cloud Storage | Blob Storage |
| Database | RDS | Cloud SQL | Azure Database |
| Network | VPC | VPC Network | Virtual Network |
| DNS | Route 53 | Cloud DNS | Azure DNS |

## Directory Structure

```
part-08-multi-cloud/
├── README.md
├── aws/                    # AWS infrastructure
│   ├── main.tf
│   └── outputs.tf
├── gcp/                    # GCP infrastructure
│   ├── main.tf
│   └── outputs.tf
└── azure/                  # Azure infrastructure
    ├── main.tf
    └── outputs.tf
```

## Examples

### AWS: EC2 + S3
```bash
cd aws/
terraform init
terraform apply
```

### GCP: Compute Engine + Cloud Storage
```bash
cd gcp/
terraform init
terraform apply
```

### Azure: VM + Blob Storage
```bash
cd azure/
terraform init
terraform apply
```

## Multi-Cloud Best Practices

### ✅ DO
- Use cloud-agnostic naming conventions
- Abstract cloud specifics behind modules
- Document cloud-specific requirements
- Test on all target clouds
- Use consistent tagging/labeling
- Consider data sovereignty requirements

### ❌ DON'T
- Hardcode cloud-specific values
- Assume feature parity across clouds
- Ignore regional availability
- Skip cost optimization per cloud
- Forget about egress costs

## Cost Warning
⚠️ Creates resources in multiple clouds!
Always destroy after testing.

## References
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/)
- [GCP Provider](https://registry.terraform.io/providers/hashicorp/google/)
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/)
