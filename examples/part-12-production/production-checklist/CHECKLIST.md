# Production Terraform Deployment Checklist

Use this checklist before deploying Terraform to production.

## Pre-Deployment

### Code Quality
- [ ] All `.tf` files formatted with `terraform fmt`
- [ ] Configuration validated with `terraform validate`
- [ ] No hardcoded secrets or credentials
- [ ] Variables properly documented in `variables.tf`
- [ ] Outputs documented in `outputs.tf`
- [ ] Code reviewed by at least one team member
- [ ] Naming conventions followed consistently

### Security
- [ ] Security scan passed (tfsec, Checkov)
- [ ] Policy checks passed (OPA/Conftest)
- [ ] No public access to sensitive resources
- [ ] Encryption enabled for data at rest
- [ ] Encryption enabled for data in transit
- [ ] IAM roles follow least privilege principle
- [ ] Secrets managed via Vault/Secrets Manager
- [ ] Network security groups properly configured
- [ ] Compliance requirements met (SOC2, HIPAA, etc.)

### State Management
- [ ] Remote backend configured (S3, GCS, Azure)
- [ ] State locking enabled (DynamoDB, Cloud Storage)
- [ ] State encryption enabled
- [ ] State backup strategy in place
- [ ] Access to state files restricted (IAM policies)
- [ ] State versioning enabled
- [ ] No local state files in repository

### Testing
- [ ] Unit tests written (Terratest)
- [ ] Integration tests passed
- [ ] Dry run in staging environment completed
- [ ] Rollback procedure tested
- [ ] Resource limits verified (quotas, limits)
- [ ] Cost estimate reviewed and approved

### Documentation
- [ ] README with setup instructions
- [ ] Architecture diagram created
- [ ] Variables documented with descriptions
- [ ] Outputs documented with descriptions
- [ ] Runbook for common operations
- [ ] Disaster recovery procedures documented
- [ ] Contact information for on-call team

### Infrastructure
- [ ] Resource tagging strategy implemented
- [ ] Monitoring and alerting configured
- [ ] Logging centralized
- [ ] Backup strategy for critical resources
- [ ] High availability configured where needed
- [ ] Auto-scaling configured where appropriate
- [ ] Disaster recovery tested

## Deployment

### Pre-Apply
- [ ] Terraform plan reviewed and approved
- [ ] Cost estimate within budget
- [ ] Change window scheduled (if required)
- [ ] Stakeholders notified
- [ ] Rollback plan ready
- [ ] Team on standby for deployment

### During Apply
- [ ] Terraform apply executed with `-auto-approve=false`
- [ ] Progress monitored in real-time
- [ ] Errors investigated immediately
- [ ] Team communication maintained

### Post-Apply
- [ ] All resources created successfully
- [ ] Outputs validated
- [ ] Application health checks passed
- [ ] Monitoring dashboards showing green
- [ ] No unexpected costs
- [ ] Documentation updated with new changes
- [ ] Deployment logged and tracked

## Post-Deployment

### Monitoring
- [ ] CloudWatch/monitoring dashboards reviewed
- [ ] Alert thresholds verified
- [ ] Log aggregation working
- [ ] Metrics collection confirmed
- [ ] Performance baselines established

### Validation
- [ ] Application functionality verified
- [ ] Integration tests passed
- [ ] User acceptance testing completed
- [ ] Performance testing passed
- [ ] Security scan post-deployment

### Operations
- [ ] On-call rotation updated
- [ ] Runbooks accessible to team
- [ ] Incident response procedures reviewed
- [ ] Backup verification scheduled
- [ ] Drift detection scheduled

## Ongoing Maintenance

### Daily
- [ ] Review monitoring dashboards
- [ ] Check for drift (automated)
- [ ] Review cost reports

### Weekly
- [ ] Review security scans
- [ ] Update dependencies
- [ ] Review access logs

### Monthly
- [ ] Disaster recovery drill
- [ ] Review and optimize costs
- [ ] Update documentation
- [ ] Review and rotate secrets
- [ ] Terraform version updates

## Emergency Procedures

### Rollback
1. Revert Git commit
2. Run `terraform plan` with previous version
3. Run `terraform apply` to rollback
4. Verify rollback successful
5. Document incident

### Disaster Recovery
1. Restore state file from backup
2. Run `terraform plan` to assess damage
3. Run `terraform apply` to restore resources
4. Verify restoration
5. Document incident and lessons learned

## Compliance

### SOC 2
- [ ] Encryption requirements met
- [ ] Access controls documented
- [ ] Audit logging enabled
- [ ] Change management followed

### HIPAA
- [ ] PHI properly encrypted
- [ ] Access restricted to authorized users
- [ ] Audit trails enabled
- [ ] Backup and recovery tested

### GDPR
- [ ] Data residency requirements met
- [ ] Data retention policies implemented
- [ ] Right to deletion supported
- [ ] Data processing documented

## Sign-Off

| Role | Name | Date | Signature |
|------|------|------|-----------|
| Developer | | | |
| DevOps Lead | | | |
| Security Lead | | | |
| Manager | | | |

## Notes

Use this section to document any deviations from the checklist or additional considerations for this specific deployment.

---

**Last Updated**: 2025-12-30
**Version**: 1.0
**Owner**: Platform Team
