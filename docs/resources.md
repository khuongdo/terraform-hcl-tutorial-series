# External Resources

Curated list of official documentation, tutorials, tools, and community resources for learning Terraform.

## Official Documentation

### HashiCorp Resources
- **[Terraform Documentation](https://developer.hashicorp.com/terraform/docs)** - Official docs
- **[Terraform Registry](https://registry.terraform.io/)** - Providers and modules
- **[HashiCorp Learn](https://developer.hashicorp.com/terraform/tutorials)** - Interactive tutorials
- **[Terraform CLI Reference](https://developer.hashicorp.com/terraform/cli)** - Command-line tools
- **[HCL Language Reference](https://developer.hashicorp.com/terraform/language)** - Syntax and semantics

### Cloud Provider Documentation
- **[AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)** - AWS resources
- **[Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)** - GCP resources
- **[Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)** - Azure resources

## Best Practices Guides

### General Best Practices
- **[Terraform Best Practices](https://www.terraform-best-practices.com/)** - Community-driven guide
- **[Google Cloud Terraform Best Practices](https://cloud.google.com/docs/terraform/best-practices-for-terraform)** - GCP-specific
- **[Azure Terraform Best Practices](https://learn.microsoft.com/azure/developer/terraform/best-practices-testing-overview)** - Azure-specific

### Security Best Practices
- **[OWASP Terraform Security Cheatsheet](https://cheatsheetseries.owasp.org/cheatsheets/Terraform_Security_Cheat_Sheet.html)**
- **[CIS Benchmarks for Terraform](https://www.cisecurity.org/)**
- **[Terraform Security Best Practices](https://developer.hashicorp.com/well-architected-framework/security)**

## Testing & Validation Tools

### Testing Frameworks
- **[Terratest](https://terratest.gruntwork.io/)** - Go-based testing framework
  - [Examples](https://github.com/gruntwork-io/terratest/tree/master/examples)
  - [Documentation](https://terratest.gruntwork.io/docs/)

### Static Analysis
- **[tfsec](https://github.com/aquasecurity/tfsec)** - Security scanner
- **[Checkov](https://www.checkov.io/)** - Policy-as-code scanner
- **[Trivy](https://github.com/aquasecurity/trivy)** - Comprehensive security scanner
- **[Terrascan](https://github.com/tenable/terrascan)** - Static code analyzer

### Policy as Code
- **[Open Policy Agent (OPA)](https://www.openpolicyagent.org/)**
- **[Conftest](https://www.conftest.dev/)** - Test structured configuration
- **[Sentinel](https://developer.hashicorp.com/sentinel)** - HashiCorp's policy framework

## Related Tools

### Infrastructure Management
- **[Terragrunt](https://terragrunt.gruntwork.io/)** - Terraform wrapper
- **[Atlantis](https://www.runatlantis.io/)** - Terraform PR automation
- **[env0](https://www.env0.com/)** - IaC platform
- **[Spacelift](https://spacelift.io/)** - Terraform automation

### Secrets Management
- **[HashiCorp Vault](https://www.vaultproject.io/)** - Secrets management
- **[SOPS](https://github.com/mozilla/sops)** - Encrypted secrets
- **[git-secret](https://git-secret.io/)** - Encrypt files in git

### Documentation
- **[terraform-docs](https://terraform-docs.io/)** - Generate documentation
- **[Rover](https://github.com/im2nguyen/rover)** - Terraform visualizer

## Community Resources

### Learning Platforms
- **[A Cloud Guru Terraform Courses](https://acloudguru.com/search?s=terraform)**
- **[Udemy Terraform Courses](https://www.udemy.com/topic/terraform/)**
- **[Pluralsight Terraform Path](https://www.pluralsight.com/paths/managing-infrastructure-with-terraform)**

### YouTube Channels
- **[HashiCorp](https://www.youtube.com/@HashiCorp)** - Official channel
- **[freeCodeCamp Terraform Tutorial](https://www.youtube.com/watch?v=SLB_c_ayRMo)**
- **[TechWorld with Nana](https://www.youtube.com/@TechWorldwithNana)** - DevOps tutorials

### Blogs & Articles
- **[HashiCorp Blog](https://www.hashicorp.com/blog)**
- **[Gruntwork Blog](https://blog.gruntwork.io/)**
- **[AWS Architecture Blog](https://aws.amazon.com/blogs/architecture/)**
- **[GCP Cloud Blog](https://cloud.google.com/blog/)**

### Books
- **"Terraform: Up & Running"** by Yevgeniy Brikman - O'Reilly
- **"Terraform in Action"** by Scott Winkler - Manning
- **"Getting Started with Terraform"** by Kirill Shirinkin - Packt

## Community Forums

### Discussion & Support
- **[HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core)** - Official forum
- **[Terraform Discord](https://discord.com/invite/terraform)** - Chat community
- **[Reddit r/Terraform](https://www.reddit.com/r/Terraform/)** - Community discussions
- **[Stack Overflow](https://stackoverflow.com/questions/tagged/terraform)** - Q&A

### Social Media
- **[Terraform Twitter](https://twitter.com/HashiCorp)** - @HashiCorp
- **[LinkedIn Terraform Group](https://www.linkedin.com/groups/6585254/)**

## Terraform Providers

### Popular Providers (beyond AWS/GCP/Azure)
- **[Kubernetes](https://registry.terraform.io/providers/hashicorp/kubernetes/latest)**
- **[Docker](https://registry.terraform.io/providers/kreuzwerker/docker/latest)**
- **[Helm](https://registry.terraform.io/providers/hashicorp/helm/latest)**
- **[Cloudflare](https://registry.terraform.io/providers/cloudflare/cloudflare/latest)**
- **[Datadog](https://registry.terraform.io/providers/DataDog/datadog/latest)**
- **[GitHub](https://registry.terraform.io/providers/integrations/github/latest)**
- **[PagerDuty](https://registry.terraform.io/providers/PagerDuty/pagerduty/latest)**

### Provider Development
- **[Terraform Plugin Framework](https://developer.hashicorp.com/terraform/plugin)**
- **[Provider Design Principles](https://developer.hashicorp.com/terraform/plugin/best-practices)**

## CI/CD Integration

### GitHub Actions
- **[hashicorp/setup-terraform](https://github.com/hashicorp/setup-terraform)** - Official action
- **[Terraform GitHub Actions Examples](https://developer.hashicorp.com/terraform/tutorials/automation/github-actions)**

### GitLab CI
- **[GitLab Terraform Integration](https://docs.gitlab.com/ee/user/infrastructure/iac/)**

### Jenkins
- **[Jenkins Terraform Plugin](https://plugins.jenkins.io/terraform/)**

### Azure DevOps
- **[Terraform Azure Pipelines](https://learn.microsoft.com/azure/devops/pipelines/tasks/reference/terraform-installer-v0)**

## Cloud-Specific Resources

### AWS
- **[AWS Quick Start](https://aws.amazon.com/quickstart/)** - Reference architectures
- **[AWS Solutions Library](https://aws.amazon.com/solutions/)**
- **[aws-samples on GitHub](https://github.com/aws-samples)**

### GCP
- **[Google Cloud Architecture Center](https://cloud.google.com/architecture)**
- **[GCP Solutions](https://cloud.google.com/solutions)**
- **[GoogleCloudPlatform on GitHub](https://github.com/GoogleCloudPlatform)**

### Azure
- **[Azure Architecture Center](https://learn.microsoft.com/azure/architecture/)**
- **[Azure Quickstart Templates](https://azure.microsoft.com/resources/templates/)**
- **[Azure Samples](https://github.com/Azure-Samples)**

## Advanced Topics

### Multi-Cloud & Hybrid
- **[Crossplane](https://www.crossplane.io/)** - Kubernetes-based multi-cloud
- **[Pulumi](https://www.pulumi.com/)** - Alternative IaC (multi-language)

### GitOps
- **[ArgoCD](https://argo-cd.readthedocs.io/)** - GitOps for Kubernetes
- **[Flux](https://fluxcd.io/)** - GitOps toolkit

### Observability
- **[Prometheus](https://prometheus.io/)** - Monitoring
- **[Grafana](https://grafana.com/)** - Visualization
- **[Datadog Terraform Provider](https://registry.terraform.io/providers/DataDog/datadog/latest)**

## Certification

### HashiCorp Certifications
- **[Terraform Associate (003)](https://www.hashicorp.com/certification/terraform-associate)** - Entry-level
- **[Study Guide](https://developer.hashicorp.com/terraform/tutorials/certification-003)**
- **[Practice Exam](https://developer.hashicorp.com/terraform/tutorials/certification-003/associate-review-003)**

## Regular Updates

### Release Notes
- **[Terraform Releases](https://github.com/hashicorp/terraform/releases)** - Changelog
- **[Provider Releases](https://github.com/hashicorp/terraform-provider-aws/releases)** - AWS example

### Newsletters
- **[HashiCorp Newsletter](https://www.hashicorp.com/newsletter-signup)**
- **[DevOps Weekly](https://www.devopsweekly.com/)**

## Contributing to Terraform

### Open Source Contribution
- **[Terraform GitHub](https://github.com/hashicorp/terraform)**
- **[Contributing Guide](https://github.com/hashicorp/terraform/blob/main/.github/CONTRIBUTING.md)**
- **[Provider Development](https://developer.hashicorp.com/terraform/plugin)**

---

**Note**: This list is actively maintained. Suggest additions by [opening an issue](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues) or [pull request](https://github.com/khuongdo/terraform-hcl-tutorial-series/pulls).

**Last Updated**: 2025-12-30
