# Terraform HCL Tutorial Series - Code Repository

[![Terraform](https://img.shields.io/badge/Terraform-1.6+-purple?logo=terraform)](https://www.terraform.io/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Docs: CC BY-SA 4.0](https://img.shields.io/badge/Docs-CC%20BY--SA%204.0-blue.svg)](LICENSE-docs)

Production-ready code examples supporting the comprehensive 12-part Terraform HCL tutorial series. Learn Infrastructure as Code from fundamentals to production DevSecOps patterns across AWS, GCP, and Azure.

📚 **[Read the Blog Series →](https://khuongdo.dev)**

---

## 🎯 What You'll Learn

This repository provides working code examples for:

- **Terraform Fundamentals**: HCL syntax, state management, workflow
- **Multi-Cloud Patterns**: Deploy to AWS, GCP, and Azure
- **Modules & Reusability**: DRY infrastructure code
- **Testing & Validation**: Terratest, tfsec, OPA policies
- **Security Best Practices**: Vault, SOPS, secrets management
- **Production Patterns**: CI/CD, disaster recovery, compliance

## 📂 Repository Structure

```
terraform-hcl-tutorial-series/
├── examples/              # Progressive code examples (Parts 1-12)
│   ├── part-01-iac-fundamentals/
│   ├── part-02-setup/
│   ├── part-03-first-resource/
│   ├── part-04-hcl-fundamentals/
│   ├── part-05-variables-state/
│   ├── part-06-workflow/
│   ├── part-07-modules/
│   ├── part-08-multi-cloud/
│   ├── part-09-state-management/
│   ├── part-10-testing/
│   ├── part-11-security/
│   └── part-12-production/
│
├── docs/                  # Documentation
│   ├── setup-guides/      # Cloud provider authentication
│   ├── troubleshooting.md # Common issues & solutions
│   ├── glossary.md        # Terraform terminology
│   └── resources.md       # External references
│
├── scripts/               # Automation scripts
│   ├── setup.sh           # Lab environment setup
│   ├── validate-all.sh    # Test all examples
│   └── cleanup-all.sh     # Destroy all resources
│
└── .github/               # CI/CD workflows
    └── workflows/         # GitHub Actions
```

## 🚀 Quick Start

### Prerequisites

- **Terraform** 1.6.0 or later ([install](https://developer.hashicorp.com/terraform/install))
- **Cloud CLI tools** (AWS CLI, gcloud, az CLI)
- **Go** 1.21+ (for Terratest examples)
- **Git**

Verify installations:

```bash
./scripts/check-prerequisites.sh
```

### Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/khuongdo/terraform-hcl-tutorial-series.git
   cd terraform-hcl-tutorial-series
   ```

2. **Set up cloud authentication** (choose your cloud):
   - [AWS Setup Guide](docs/setup-guides/aws-setup.md)
   - [GCP Setup Guide](docs/setup-guides/gcp-setup.md)
   - [Azure Setup Guide](docs/setup-guides/azure-setup.md)

3. **Start with Part 2** (provider setup):
   ```bash
   cd examples/part-02-setup/aws/
   terraform init
   terraform plan
   terraform apply
   ```

4. **Follow the blog series** for detailed explanations:
   - [Part 1: Why Infrastructure as Code?](https://khuongdo.dev/posts/terraform-part-01-iac-fundamentals)
   - [Part 2: Setting Up Terraform](#)
   - [Part 3: Your First Cloud Resource](#)
   - ... and more

## 📖 Tutorial Series Overview

| Part | Topic | Cloud(s) | Difficulty |
|------|-------|----------|------------|
| 1 | Infrastructure as Code Fundamentals | Conceptual | Beginner |
| 2 | Setting Up Terraform | AWS/GCP/Azure | Beginner |
| 3 | Your First Cloud Resource | AWS | Beginner |
| 4 | HCL Fundamentals | AWS | Beginner |
| 5 | Variables, Outputs & State | AWS | Beginner |
| 6 | Core Terraform Workflow | AWS | Intermediate |
| 7 | Modules: Organization & Reusability | AWS | Intermediate |
| 8 | Multi-Cloud Patterns | AWS/GCP/Azure | Intermediate |
| 9 | State Management & Team Workflows | AWS/GCP/Azure | Intermediate |
| 10 | Testing & Validation | AWS | Advanced |
| 11 | Security & Secrets Management | AWS | Advanced |
| 12 | Production Patterns & DevSecOps | AWS | Advanced |

## 💡 Learning Path

### Beginner Track (Parts 1-5)
Start here if you're new to Terraform:
1. Understand IaC concepts (Part 1)
2. Install and configure providers (Part 2)
3. Deploy your first resource (Part 3)
4. Master HCL syntax (Part 4)
5. Learn variables and state (Part 5)

### Intermediate Track (Parts 6-9)
Ready to build real infrastructure:
1. Terraform workflow mastery (Part 6)
2. Create reusable modules (Part 7)
3. Deploy across multiple clouds (Part 8)
4. Team collaboration patterns (Part 9)

### Advanced Track (Parts 10-12)
Production-ready infrastructure:
1. Automated testing (Part 10)
2. Security best practices (Part 11)
3. CI/CD and production patterns (Part 12)

## ⚠️ Cost Warning

**These examples create real cloud resources that may incur charges.**

- Most examples use free-tier eligible resources (t2.micro, etc.)
- **Always run `terraform destroy` when done**
- Check your cloud provider's billing dashboard
- Use cost calculators before deploying large examples

We provide cleanup scripts for easy resource destruction:
```bash
# Clean up all resources in all examples
./scripts/cleanup-all.sh

# Or clean up specific part
cd examples/part-03-first-resource/
terraform destroy
```

## 🧪 Testing & Validation

All examples include:
- ✅ Terraform validation (`terraform validate`)
- ✅ Format checking (`terraform fmt`)
- ✅ Security scanning (tfsec)
- ✅ Automated testing (Terratest, where applicable)

Run CI/CD checks locally:
```bash
# Validate all examples
./scripts/validate-all.sh

# Security scan
tfsec examples/
```

## 📚 Additional Resources

### Official Documentation
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Terraform Registry](https://registry.terraform.io/)
- [HashiCorp Learn](https://developer.hashicorp.com/terraform/tutorials)

### Community
- [Terraform Best Practices](https://www.terraform-best-practices.com/)
- [Terraform Discord](https://discord.com/invite/terraform)
- [HashiCorp Discuss](https://discuss.hashicorp.com/c/terraform-core)

### Related Projects
- [Terratest](https://terratest.gruntwork.io/) - Testing framework
- [tfsec](https://github.com/aquasecurity/tfsec) - Security scanner
- [Checkov](https://www.checkov.io/) - Policy-as-code
- [Terraform-Docs](https://terraform-docs.io/) - Documentation generator

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to report bugs
- How to suggest improvements
- Code style guidelines
- Pull request process

## 📄 License

- **Code**: [MIT License](LICENSE) - Use freely in your projects
- **Documentation**: [CC BY-SA 4.0](LICENSE-docs) - Share and adapt with attribution

## 🙏 Acknowledgments

This series is inspired by:
- HashiCorp's official Terraform tutorials
- The Terraform community's best practices
- Real-world production infrastructure patterns
- Feedback from hundreds of infrastructure engineers

## 📧 Support & Feedback

- **Blog Comments**: Leave feedback on individual tutorial posts
- **GitHub Issues**: [Report bugs or request features](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues)
- **Discussions**: [Ask questions and share ideas](https://github.com/khuongdo/terraform-hcl-tutorial-series/discussions)

---

**Ready to master Terraform?** Start with [Part 1: Why Infrastructure as Code?](https://khuongdo.dev/posts/terraform-part-01-iac-fundamentals) →
