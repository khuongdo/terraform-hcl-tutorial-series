# Part 10: Testing Terraform

Automated testing with Terratest, tfsec, and OPA policy enforcement.

## What You'll Learn
- Unit testing with Terratest (Go)
- Security scanning with tfsec
- Policy as code with OPA/Conftest
- Integration testing patterns
- CI/CD test automation

## Testing Tools

### Terratest (Go)
Automated infrastructure testing framework.

### tfsec
Static analysis security scanner for Terraform.

### OPA (Open Policy Agent)
Policy as code for compliance checking.

## Quick Start

### Security Scan
```bash
cd terratest/
tfsec .
```

### Policy Check
```bash
cd opa/
conftest test *.tf -p policy/
```

### Terratest
```bash
cd terratest/
go test -v -timeout 30m
```

## Examples

- `terratest/` - Go test examples
- `tfsec/` - Security scan configuration
- `opa/` - Policy examples

## CI/CD Integration

```yaml
- name: Security Scan
  run: tfsec . --soft-fail

- name: Policy Check
  run: conftest test *.tf

- name: Terratest
  run: go test -v
```

## References
- [Terratest](https://terratest.gruntwork.io/)
- [tfsec](https://aquasecurity.github.io/tfsec/)
- [OPA](https://www.openpolicyagent.org/)
