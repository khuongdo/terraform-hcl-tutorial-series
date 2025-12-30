# Part 7: Terraform Modules

Create and consume reusable Terraform modules for DRY infrastructure code.

## What You'll Learn
- Create custom modules
- Module inputs (variables) and outputs
- Module composition patterns
- Use public modules from Terraform Registry
- Module versioning and best practices
- Module testing and documentation

## Prerequisites
- AWS account configured
- Terraform 1.6+ installed
- Understanding of Parts 1-6

## Directory Structure

```
part-07-modules/
├── README.md                       # This file
├── modules/
│   └── web-server/                 # Custom reusable module
│       ├── main.tf                 # Module resources
│       ├── variables.tf            # Module inputs
│       ├── outputs.tf              # Module outputs
│       └── README.md               # Module documentation
├── using-custom-module/            # Example using custom module
│   ├── main.tf
│   └── outputs.tf
└── using-registry-module/          # Example using public module
    ├── main.tf
    └── outputs.tf
```

## Module Concepts

### What is a Module?
A module is a container for multiple resources used together. Every Terraform configuration has at least one module (the root module).

### Why Use Modules?
- **Reusability**: Write once, use many times
- **Organization**: Logical grouping of resources
- **Encapsulation**: Hide complexity behind simple interface
- **Consistency**: Enforce standards across environments
- **Testing**: Test modules independently

## Creating Custom Modules

See `modules/web-server/` for a complete example of a reusable web server module.

### Module Structure Best Practices

```
module-name/
├── main.tf          # Main resource definitions
├── variables.tf     # Input variable declarations
├── outputs.tf       # Output value declarations
├── README.md        # Module documentation
├── versions.tf      # Provider version constraints (optional)
└── examples/        # Example usage (optional)
```

### Module Inputs (Variables)

Define module configuration options:

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
```

### Module Outputs

Expose resource attributes for use by calling module:

```hcl
output "instance_id" {
  description = "ID of created EC2 instance"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.web.public_ip
}
```

## Using Custom Modules

### Local Module Source

```hcl
module "web_server" {
  source = "./modules/web-server"

  instance_type = "t2.small"
  environment   = "production"

  tags = {
    Team = "platform"
  }
}
```

### Git Module Source

```hcl
module "web_server" {
  source = "git::https://github.com/your-org/terraform-modules.git//web-server?ref=v1.0.0"

  instance_type = "t2.small"
}
```

### Terraform Registry Source

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
}
```

## Module Versioning

### Git Tags
```hcl
module "example" {
  source = "git::https://github.com/org/repo.git//module?ref=v1.2.3"
}
```

### Terraform Registry Versions
```hcl
module "example" {
  source  = "hashicorp/example/aws"
  version = "~> 1.0"  # Any 1.x version
}
```

### Version Constraints
- `= 1.0.0` - Exact version
- `!= 1.0.0` - Exclude version
- `> 1.0.0` - Greater than
- `>= 1.0.0` - Greater than or equal
- `< 2.0.0` - Less than
- `<= 2.0.0` - Less than or equal
- `~> 1.0` - Pessimistic constraint (>= 1.0, < 2.0)

## Module Composition

Modules can call other modules:

```hcl
# In modules/application/main.tf
module "vpc" {
  source = "../networking/vpc"
  cidr   = var.vpc_cidr
}

module "database" {
  source = "../data/rds"
  vpc_id = module.vpc.vpc_id
}
```

## Examples

### Example 1: Using Custom Module

```bash
cd using-custom-module
terraform init
terraform plan
terraform apply
```

Creates web server using the local `modules/web-server` module.

### Example 2: Using Registry Module

```bash
cd using-registry-module
terraform init
terraform plan
terraform apply
```

Uses official AWS VPC module from Terraform Registry.

## Module Best Practices

### ✅ DO
- Keep modules focused (single responsibility)
- Document all variables and outputs
- Use semantic versioning for releases
- Provide examples in module repository
- Test modules before releasing
- Use consistent naming conventions
- Declare required provider versions
- Make modules reusable across environments

### ❌ DON'T
- Hardcode values (use variables)
- Use provider configurations in modules (unless root)
- Create circular dependencies
- Expose too many outputs (only what's needed)
- Make modules too complex
- Forget to version modules
- Use state in modules (modules should be stateless)

## Module Documentation Template

```markdown
# Module Name

Brief description of what the module does.

## Usage

\`\`\`hcl
module "example" {
  source = "./modules/example"

  required_var = "value"
  optional_var = "value"
}
\`\`\`

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| required_var | Description | string | n/a | yes |
| optional_var | Description | string | "default" | no |

## Outputs

| Name | Description |
|------|-------------|
| output_name | Description |

## Examples

See `examples/` directory.
```

## Testing Modules

### Manual Testing
```bash
cd modules/web-server/examples
terraform init
terraform apply
terraform destroy
```

### Automated Testing
See Part 10 for Terratest examples.

## Publishing Modules

### Private Registry (Terraform Cloud)
1. Create module repository
2. Tag releases with semantic versions
3. Connect to Terraform Cloud registry

### Public Registry
1. Follow [module structure](https://developer.hashicorp.com/terraform/registry/modules/publish)
2. Create GitHub repository: `terraform-<PROVIDER>-<NAME>`
3. Tag releases: `vX.Y.Z`
4. Registry auto-discovers modules

## Common Module Patterns

### Feature Flags
```hcl
variable "enable_monitoring" {
  type    = bool
  default = false
}

resource "aws_cloudwatch_metric_alarm" "cpu" {
  count = var.enable_monitoring ? 1 : 0
  # ...
}
```

### Conditional Resources
```hcl
resource "aws_instance" "web" {
  count = var.instance_count
  # ...
}
```

### Dynamic Blocks
```hcl
dynamic "ingress" {
  for_each = var.ingress_rules
  content {
    from_port = ingress.value.from
    to_port   = ingress.value.to
    protocol  = ingress.value.protocol
  }
}
```

## Cost Warning
⚠️ Examples create AWS resources (EC2, VPC, etc.)
Always run `terraform destroy` after testing.

## Troubleshooting

**Error: "Module not installed"**
- Run `terraform init` to download modules

**Error: "Unsupported attribute"**
- Check module outputs: `terraform console` → `module.name`

**Error: "Module version constraint"**
- Update `version` argument in module block
- Run `terraform init -upgrade`

## Next Steps
- Create multi-cloud deployments (Part 8)
- Set up remote state backends (Part 9)
- Test modules with Terratest (Part 10)

## References
- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)
- [Terraform Registry](https://registry.terraform.io/)
- [Module Development](https://developer.hashicorp.com/terraform/language/modules/develop)
