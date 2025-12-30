# Part 1: Why Infrastructure as Code?

This part covers the fundamental concepts of Infrastructure as Code (IaC) and why Terraform has become the industry standard.

**📚 Read the full tutorial**: [Part 1: Why Infrastructure as Code?](https://khuongdo.dev/posts/terraform-part-01-iac-fundamentals)

---

## Overview

Part 1 is **conceptual** - there's no runnable code in this directory. Instead, you'll learn:

- What Infrastructure as Code means and why it matters
- The difference between declarative and imperative approaches
- How Terraform compares to alternatives (CloudFormation, Pulumi, Ansible)
- When to use Terraform vs other tools
- Real-world success stories and use cases

## No Code to Run

Unlike other parts of this series, Part 1 focuses on understanding core concepts. You won't deploy any infrastructure yet - that starts in **Part 2** with provider setup and **Part 3** with your first resource.

**Next step**: Once you understand IaC fundamentals, move to [Part 2: Setting Up Terraform](../part-02-setup/)

---

## Key Concepts Covered

### Infrastructure as Code (IaC)

Managing and provisioning infrastructure through machine-readable configuration files rather than manual processes.

**Manual Infrastructure** (❌ Don't do this):
```
1. Log into AWS Console
2. Click "Launch Instance"
3. Select AMI, instance type, network...
4. Click through 15 configuration screens
5. Hope you remember all settings for next time
6. Manually replicate in staging
```

**Infrastructure as Code** (✅ Do this):
```hcl
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server"
  }
}
```

Run `terraform apply` → Infrastructure created. Every time. Consistently.

### Declarative vs Imperative

See [diagrams/declarative-vs-imperative.md](diagrams/declarative-vs-imperative.md) for visual comparison.

**Imperative** (Bash, Ansible):
- Tell the system **how** to do something (step-by-step)
- Order matters
- Errors are hard to recover from
- Not idempotent

**Declarative** (Terraform, CloudFormation):
- Tell the system **what** you want (desired state)
- Terraform figures out the "how"
- Run multiple times = same result (idempotent)
- Easier to understand and maintain

### Why Terraform?

**Multi-Cloud**:
- Single tool for AWS, GCP, Azure, and 3,000+ providers
- Same workflow, same language across clouds

**Declarative HCL**:
- Human-readable configuration language
- Designed specifically for infrastructure

**State Management**:
- Tracks current infrastructure state
- Detects drift and changes

**Massive Ecosystem**:
- 100,000+ modules in Terraform Registry
- Active community and enterprise support

**See also**: [Terraform vs Alternatives](terraform-vs-alternatives.md) for detailed comparison

---

## Learning Objectives

After reading Part 1 and reviewing these materials, you should be able to:

- ✅ Explain what Infrastructure as Code means
- ✅ Describe the difference between declarative and imperative approaches
- ✅ List 3 benefits of using Terraform
- ✅ Compare Terraform to CloudFormation and Pulumi
- ✅ Decide when to use Terraform vs other tools
- ✅ Understand Terraform's value proposition

## Self-Assessment Quiz

Test your understanding:

1. **What is Infrastructure as Code?**
   <details>
   <summary>Answer</summary>
   Managing infrastructure through machine-readable configuration files instead of manual processes or interactive tools.
   </details>

2. **What's the difference between declarative and imperative?**
   <details>
   <summary>Answer</summary>
   Declarative describes the desired end state ("I want 3 servers"). Imperative provides step-by-step instructions ("Create server 1, then server 2...").
   </details>

3. **Why choose Terraform over CloudFormation?**
   <details>
   <summary>Answer</summary>
   Terraform is multi-cloud (works with AWS, GCP, Azure, etc.), has a larger provider ecosystem, and uses a more readable configuration language (HCL vs JSON/YAML).
   </details>

4. **Is Terraform idempotent?**
   <details>
   <summary>Answer</summary>
   Yes. Running the same Terraform configuration multiple times produces the same result. If infrastructure matches the desired state, Terraform does nothing.
   </details>

---

## Additional Materials

### Conceptual Diagrams

- [Declarative vs Imperative](diagrams/declarative-vs-imperative.md) - Visual comparison
- [Terraform vs Alternatives](terraform-vs-alternatives.md) - Decision matrix

### External Resources

- [HashiCorp's "What is Terraform?"](https://developer.hashicorp.com/terraform/intro)
- [Terraform Use Cases](https://developer.hashicorp.com/terraform/intro/use-cases)
- [IaC Wikipedia](https://en.wikipedia.org/wiki/Infrastructure_as_code)

### Real-World Examples

The blog post includes several case studies:
- **Fintech**: Multi-region disaster recovery (2 hours → 15 minutes deployment)
- **SaaS Startup**: Customer environment provisioning (2 days → 10 minutes)
- **Healthcare**: HIPAA compliance with full audit trail

---

## What's Next?

### Part 2: Setting Up Terraform

Now that you understand **why** Infrastructure as Code, Part 2 covers **how** to get started:

- Install Terraform CLI
- Configure AWS/GCP/Azure authentication
- Initialize your first Terraform project
- Understand provider concepts

**Continue to**: [Part 2: Setting Up Terraform](../part-02-setup/) →

---

## Series Navigation

- **Part 1: Why Infrastructure as Code?** ← You are here
- [Part 2: Setting Up Terraform](../part-02-setup/)
- [Part 3: Your First Cloud Resource](../part-03-first-resource/)
- [Part 4: HCL Fundamentals](../part-04-hcl-fundamentals/)
- [All Parts](../../README.md#tutorial-series-overview)

---

**Questions?** Check the [Troubleshooting Guide](../../docs/troubleshooting.md) or [open an issue](https://github.com/khuongdo/terraform-hcl-tutorial-series/issues).
