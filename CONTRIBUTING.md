# Contributing to Terraform HCL Tutorial Series

Thank you for your interest in contributing! This repository provides code examples for a 12-part Terraform tutorial series, and we welcome improvements, bug fixes, and suggestions.

## How to Contribute

### Reporting Bugs

If you find a bug in the code examples:

1. **Check existing issues** to avoid duplicates
2. **Use the bug report template** when creating a new issue
3. **Include**:
   - Which tutorial part (e.g., "Part 3: First Resource")
   - Cloud provider (AWS, GCP, Azure)
   - Terraform version
   - Error message or unexpected behavior
   - Steps to reproduce

### Suggesting Improvements

We welcome suggestions for:
- Code example improvements
- Additional cloud providers
- Better documentation
- New testing scenarios
- Performance optimizations

Create an issue using the **feature request template**.

### Submitting Code Changes

#### Before You Start

1. **Fork the repository**
2. **Create a feature branch**:
   ```bash
   git checkout -b fix/part-03-ami-issue
   # or
   git checkout -b feature/add-digitalocean-example
   ```

3. **Test your changes**:
   ```bash
   # Format code
   terraform fmt -recursive examples/

   # Validate
   terraform validate

   # Run security scan
   tfsec examples/
   ```

#### Pull Request Guidelines

**Good PRs**:
- ✅ Fix a specific bug with clear description
- ✅ Improve documentation or examples
- ✅ Add missing test cases
- ✅ Follow existing code style

**Avoid**:
- ❌ Large refactors without prior discussion
- ❌ Unrelated changes in one PR
- ❌ Breaking changes without deprecation notice

**PR Template**:
```markdown
## Description
Brief description of changes

## Related Issue
Fixes #123

## Testing
- [ ] Terraform validate passes
- [ ] Terraform fmt applied
- [ ] Tested on AWS/GCP/Azure (specify which)
- [ ] Security scan passes (tfsec)

## Screenshots (if applicable)
terraform plan output or relevant screenshots
```

## Code Standards

### Terraform Code Style

Follow [HashiCorp's Terraform Style Guide](https://developer.hashicorp.com/terraform/language/style):

**Formatting**:
```hcl
# Good
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}

# Bad (inconsistent spacing, formatting)
resource "aws_instance" "web" {
ami = data.aws_ami.ubuntu.id
  instance_type="t2.micro"
  tags={Name="web-server"}
}
```

**Naming Conventions**:
- Resources: `<resource_type>.<descriptive_name>` (e.g., `aws_instance.web`)
- Variables: `snake_case` (e.g., `instance_type`)
- Locals: `snake_case` (e.g., `common_tags`)
- Modules: `kebab-case` directories (e.g., `web-server-module/`)

**Comments**:
```hcl
# Good: Explain WHY, not WHAT
# Use t2.micro for cost optimization in non-prod
instance_type = "t2.micro"

# Bad: States the obvious
# Set instance type to t2.micro
instance_type = "t2.micro"
```

### Documentation

**README Structure** (for each example):
```markdown
# Part N: Tutorial Title

Brief description (1-2 sentences)

## Prerequisites
- Required tools
- Cloud provider setup

## Usage
Step-by-step instructions

## Cost Warning
Expected costs and cleanup instructions

## Troubleshooting
Common issues and solutions
```

### Testing

All code changes must:
1. Pass `terraform fmt -check`
2. Pass `terraform validate`
3. Pass `tfsec` security scan (or document exceptions)
4. Include working examples tested on target cloud

**Testing locally**:
```bash
# Format check
terraform fmt -check -recursive examples/

# Validate all examples
for dir in examples/part-*/; do
  cd "$dir"
  terraform init -backend=false
  terraform validate
  cd -
done

# Security scan
tfsec examples/
```

## Repository Structure

Maintain this structure when adding new examples:

```
examples/part-NN-topic-name/
├── README.md              # Always required
├── main.tf                # Primary configuration
├── variables.tf           # Input variables
├── outputs.tf             # Outputs
├── terraform.tf           # Provider config
└── *.tfvars.example       # Example variable values
```

## Commit Message Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

**Format**:
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature or example
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting changes
- `refactor`: Code refactor
- `test`: Test additions
- `chore`: Maintenance tasks

**Examples**:
```bash
# Good
feat(part-03): add user_data example for EC2 instance
fix(part-08): correct GCP service account permissions
docs(part-05): clarify variable validation syntax

# Bad
Update files
Fixed stuff
Part 3 changes
```

## Code Review Process

1. **Automated checks** run on all PRs (formatting, validation, security)
2. **Maintainer review** within 2-5 business days
3. **Feedback incorporation** (if requested)
4. **Approval and merge**

### Review Criteria

We check for:
- ✅ Code works as intended
- ✅ Follows Terraform best practices
- ✅ Documentation is clear
- ✅ No security vulnerabilities
- ✅ Cost-conscious (uses smallest viable resources)
- ✅ Includes cleanup instructions

## Getting Help

- **Questions**: [GitHub Discussions](https://github.com/khuongdo/terraform-hcl-tutorial-series/discussions)
- **Bug Reports**: [GitHub Issues](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues)
- **Chat**: [Terraform Discord](https://discord.com/invite/terraform)

## License

By contributing, you agree that your contributions will be licensed under:
- **Code**: MIT License
- **Documentation**: CC BY-SA 4.0

See [LICENSE](LICENSE) and [LICENSE-docs](LICENSE-docs) for details.

## Recognition

Contributors are recognized in:
- GitHub contributors list
- Release notes (for significant contributions)
- Blog post acknowledgments (when applicable)

---

Thank you for helping make this tutorial series better! 🙌
