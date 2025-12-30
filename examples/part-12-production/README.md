# Part 12: Production Patterns

Production-ready Terraform with CI/CD, drift detection, and cost optimization.

## What You'll Learn
- CI/CD pipeline design
- Drift detection automation
- Cost estimation (Infracost)
- Production deployment checklist
- Disaster recovery patterns

## Production Checklist

### Code Quality
- [ ] All code formatted (`terraform fmt`)
- [ ] Validation passes (`terraform validate`)
- [ ] Security scan clean (tfsec)
- [ ] Policy checks pass (OPA)
- [ ] Peer code review completed

### State Management
- [ ] Remote backend configured
- [ ] State locking enabled
- [ ] State encryption enabled
- [ ] Backup strategy in place
- [ ] Access controls configured (IAM)

### Security
- [ ] No secrets in code
- [ ] Vault/Secrets Manager integration
- [ ] Least privilege IAM
- [ ] Network security configured
- [ ] Compliance requirements met

### Monitoring
- [ ] Resource tagging strategy
- [ ] CloudWatch/monitoring enabled
- [ ] Alert thresholds configured
- [ ] Logging centralized
- [ ] Drift detection scheduled

### Documentation
- [ ] README with usage instructions
- [ ] Architecture diagrams
- [ ] Runbook for common operations
- [ ] Disaster recovery procedures
- [ ] Cost estimates documented

## CI/CD Pipeline

```yaml
name: Terraform Production

on:
  pull_request:
    branches: [main]
  push:
    branches: [main]

jobs:
  plan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: hashicorp/setup-terraform@v3

      - name: Terraform Format
        run: terraform fmt -check

      - name: Terraform Init
        run: terraform init

      - name: Terraform Validate
        run: terraform validate

      - name: Terraform Plan
        run: terraform plan -out=tfplan

      - name: Security Scan
        run: tfsec .

      - name: Cost Estimate
        run: infracost breakdown --path=tfplan

  apply:
    needs: plan
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - name: Terraform Apply
        run: terraform apply -auto-approve tfplan
```

## Drift Detection

```bash
# Daily cron job
0 9 * * * cd /terraform && terraform plan -detailed-exitcode || notify-team
```

## Cost Optimization

- Use Infracost for cost estimates
- Right-size instances based on metrics
- Use spot/preemptible instances where appropriate
- Enable auto-scaling
- Schedule dev/test environments

## References
- [Terraform Cloud](https://cloud.hashicorp.com/products/terraform)
- [Infracost](https://www.infracost.io/)
- [Atlantis](https://www.runatlantis.io/)
