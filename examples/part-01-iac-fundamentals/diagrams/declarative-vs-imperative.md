# Declarative vs Imperative: Visual Comparison

Understanding the difference between declarative and imperative approaches is crucial for mastering Terraform.

---

## Imperative Approach

**"Tell me HOW to do it, step by step"**

```
┌─────────────────────────────────────────────────────┐
│  Imperative (Bash Script Example)                   │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Step 1: aws ec2 create-vpc --cidr 10.0.0.0/16     │
│           ↓                                         │
│  Step 2: aws ec2 create-subnet --vpc vpc-123       │
│           ↓                                         │
│  Step 3: aws ec2 run-instances --subnet sub-456    │
│           ↓                                         │
│  Step 4: aws ec2 create-security-group ...         │
│           ↓                                         │
│  Done                                               │
│                                                      │
│  Problems:                                          │
│  ❌ What if VPC already exists?                    │
│  ❌ What if script fails at Step 2?                │
│  ❌ How do you cleanly delete everything?          │
│  ❌ Order matters (run out of sequence = failure)  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Bash Script Example**:
```bash
#!/bin/bash
# Imperative approach - YOU manage the workflow

# Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text)

# Create subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --query 'Subnet.SubnetId' --output text)

# Launch instance
INSTANCE_ID=$(aws ec2 run-instances --image-id ami-123 --instance-type t2.micro --subnet-id $SUBNET_ID --query 'Instances[0].InstanceId' --output text)

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

echo "Done! Instance: $INSTANCE_ID"
```

**Issues**:
- If VPC already exists, script fails
- If script crashes mid-way, partial infrastructure
- No state tracking
- Cleanup requires separate delete script
- Must handle idempotency manually

---

## Declarative Approach

**"Tell me WHAT you want, I'll figure out HOW"**

```
┌─────────────────────────────────────────────────────┐
│  Declarative (Terraform Example)                    │
├─────────────────────────────────────────────────────┤
│                                                      │
│  Desired State:                                     │
│  ┌──────────────────────────────────────┐          │
│  │ I want:                               │          │
│  │ - VPC with CIDR 10.0.0.0/16          │          │
│  │ - Subnet with CIDR 10.0.1.0/24       │          │
│  │ - EC2 instance (t2.micro)            │          │
│  │ - Security group allowing HTTP       │          │
│  └──────────────────────────────────────┘          │
│                     ↓                                │
│         Terraform figures out:                      │
│         - What already exists                       │
│         - What needs to be created                  │
│         - What needs to be updated                  │
│         - Correct order of operations               │
│                     ↓                                │
│              Infrastructure                         │
│                                                      │
│  Benefits:                                          │
│  ✅ Run multiple times = same result (idempotent)  │
│  ✅ Terraform handles dependencies automatically    │
│  ✅ Easy cleanup: terraform destroy                │
│  ✅ State tracked automatically                    │
│                                                      │
└─────────────────────────────────────────────────────┘
```

**Terraform Example**:
```hcl
# Declarative approach - Terraform manages the workflow

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_instance" "web" {
  ami           = "ami-123"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id
}

resource "aws_security_group" "web" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

**Benefits**:
- First run: Creates everything
- Second run: Does nothing (already at desired state)
- Change a value: Updates only what changed
- Terraform calculates correct order (VPC → Subnet → Instance)
- `terraform destroy`: Cleanly removes everything

---

## Side-by-Side Comparison

| Aspect | Imperative (Bash/Ansible) | Declarative (Terraform) |
|--------|---------------------------|-------------------------|
| **Definition** | Step-by-step instructions | Desired end state |
| **Example** | "Create VPC, then subnet, then instance" | "I want a VPC, subnet, and instance" |
| **Order** | YOU specify order | Terraform determines order |
| **Idempotent** | Must implement yourself | Built-in |
| **State** | Manual tracking | Automatic tracking |
| **Error Recovery** | Complex | Terraform retries from last good state |
| **Cleanup** | Write separate delete script | `terraform destroy` |
| **Change Detection** | Manual comparison | Automatic drift detection |
| **Dependencies** | Manual handling | Automatic resolution |

---

## Real-World Scenario

### Scenario: Add a second EC2 instance

**Imperative Approach**:
```bash
# Must determine:
# 1. Does VPC already exist? (check manually)
# 2. Does subnet already exist? (check manually)
# 3. Only create the new instance
# 4. Handle errors if instance already exists

if aws ec2 describe-instances --filters "Name=tag:Name,Values=web-2" | grep -q "InstanceId"; then
  echo "Instance already exists, skipping..."
else
  INSTANCE_ID=$(aws ec2 run-instances --image-id ami-123 --instance-type t2.micro --subnet-id $SUBNET_ID --query 'Instances[0].InstanceId' --output text)
  aws ec2 create-tags --resources $INSTANCE_ID --tags Key=Name,Value=web-2
fi
```

**Declarative Approach**:
```hcl
# Just add the resource:
resource "aws_instance" "web_2" {
  ami           = "ami-123"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "web-2"
  }
}
```

Run `terraform apply`:
- Terraform sees existing VPC, subnet, first instance → leaves them alone
- Terraform sees new instance definition → creates only that
- Done

---

## When Does Each Approach Make Sense?

### Use Imperative (Bash, Python scripts) When:
- One-time tasks
- Complex business logic
- Data processing
- Quick automation scripts
- Interacting with non-infrastructure APIs

### Use Declarative (Terraform) When:
- Managing cloud infrastructure
- Team collaboration needed
- Reproducible environments required
- State tracking important
- Idempotency critical

---

## Key Takeaway

```
Imperative:  "Execute these 10 commands in order"
             ↓
       Error-prone, complex cleanup, manual state

Declarative: "This is what I want to exist"
             ↓
       Idempotent, automatic state, easy cleanup
```

**Terraform is declarative** - you describe the desired infrastructure state, and Terraform figures out how to achieve it. This is why Terraform configurations are easier to understand, maintain, and collaborate on than imperative scripts.

---

**Next**: Read [Part 1 Blog Post](https://khuongdo.dev/posts/terraform-part-01-iac-fundamentals) for deeper explanation and real-world examples.
