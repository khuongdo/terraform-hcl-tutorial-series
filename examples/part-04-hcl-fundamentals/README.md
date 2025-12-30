# Part 4: HCL Fundamentals

Deep dive into HashiCorp Configuration Language syntax, types, expressions, and built-in functions.

**Cost**: $0.00 (no resources created, local evaluation only)

---

## What You'll Learn

- HCL type system (string, number, bool, list, map, object, tuple)
- Conditional expressions and ternary operators
- String interpolation and templating
- For expressions and splat operators
- Built-in functions (string, collection, type conversion, file operations)
- Local values for DRY code
- Variable validation patterns

---

## Directory Structure

```
part-04-hcl-fundamentals/
├── README.md
├── 01-types/                  # Type system examples
│   ├── main.tf                # Primitive and complex types
│   └── terraform.tfvars.example
├── 02-expressions/            # Conditional logic and loops
│   ├── conditionals.tf
│   └── for-expressions.tf
├── 03-functions/              # Built-in function examples
│   ├── string-functions.tf
│   ├── collection-functions.tf
│   └── file-functions.tf
└── 04-locals/                 # Local values for DRY patterns
    └── locals.tf
```

---

## Usage

These examples demonstrate syntax without creating cloud resources. Run them to see outputs:

### 1. Explore Type System

```bash
cd 01-types/
terraform init
terraform apply
```

See examples of all HCL types with validation.

### 2. Test Conditional Logic

```bash
cd 02-expressions/
terraform init

# Try different environments
terraform apply -var="environment=dev"
terraform apply -var="environment=prod"
```

### 3. Experiment with Functions

```bash
cd 03-functions/
terraform init
terraform apply
```

See string manipulation, collection operations, and file handling.

### 4. Use Local Values

```bash
cd 04-locals/
terraform init
terraform apply
```

Learn DRY patterns with locals.

---

## Key Concepts

### Type System

**Primitive Types**:
- `string` - Text values
- `number` - Numeric values (int or float)
- `bool` - true/false

**Complex Types**:
- `list(type)` - Ordered collection
- `map(type)` - Key-value pairs
- `object({...})` - Structured data with different types
- `tuple([...])` - Fixed-length with mixed types

### Conditional Expressions

```hcl
# Ternary operator
instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"

# Nested conditionals
log_retention = (
  var.environment == "prod" ? 90 :
  var.environment == "staging" ? 30 :
  7  # default
)
```

### For Expressions

```hcl
# Transform list
upper_azs = [for az in var.availability_zones : upper(az)]

# Filter list
prod_envs = [for env in var.environments : env if env == "prod"]

# Transform map
instance_ids = {for k, v in var.instances : k => v.id}
```

### Common Functions

**String**:
- `format()` - String formatting
- `join()`, `split()` - String concatenation/splitting
- `upper()`, `lower()` - Case conversion
- `regex()` - Pattern matching

**Collection**:
- `length()` - Count elements
- `lookup()` - Safe map access
- `merge()` - Combine maps
- `contains()` - Check membership

**Type Conversion**:
- `tostring()`, `tonumber()`, `tobool()`
- `tolist()`, `tomap()`, `toset()`

---

## Examples

### Variable Validation

```hcl
variable "environment" {
  type = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}
```

### Local Values

```hcl
locals {
  # Common tags
  common_tags = {
    Project     = "terraform-tutorial"
    ManagedBy   = "terraform"
    Environment = var.environment
  }

  # Computed values
  resource_prefix = "${var.project_name}-${var.environment}"

  # Conditional logic
  instance_count = var.environment == "prod" ? 10 : 2
}
```

---

## Best Practices

1. **Use Type Constraints**: Always specify variable types
2. **Validate Inputs**: Add validation rules for critical variables
3. **DRY with Locals**: Extract repeated expressions to locals
4. **Descriptive Names**: Use clear variable and local names
5. **Document Complex Logic**: Add comments for non-obvious conditionals
6. **Prefer Built-in Functions**: Use Terraform functions over external scripts

---

## Next Steps

✅ Mastered HCL syntax
✅ Understood type system
✅ Learned expressions and functions

**Continue to**:
- [Part 5: Variables and State](../part-05-variables-state/) - Input/output patterns
- [Part 6: Workflow](../part-06-workflow/) - Advanced CLI usage

---

## Additional Resources

- [HCL Configuration Syntax](https://developer.hashicorp.com/terraform/language/syntax/configuration)
- [Terraform Functions](https://developer.hashicorp.com/terraform/language/functions)
- [Variable Validation](https://developer.hashicorp.com/terraform/language/values/variables#custom-validation-rules)
