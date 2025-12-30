# Web Server Module

Reusable module for creating EC2-based web servers with security groups.

## Usage

```hcl
module "web_server" {
  source = "./modules/web-server"

  name_prefix   = "my-app"
  instance_type = "t2.small"

  allowed_ports = [80, 443, 22]
  allowed_cidrs = ["10.0.0.0/8"]

  tags = {
    Environment = "production"
    Team        = "platform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name_prefix | Prefix for resource names | string | n/a | yes |
| instance_type | EC2 instance type | string | "t2.micro" | no |
| ami_id | AMI ID (auto-detects if empty) | string | "" | no |
| volume_size | Root volume size (GB) | number | 20 | no |
| volume_type | Root volume type | string | "gp3" | no |
| allowed_ports | Inbound ports | list(number) | [80, 443] | no |
| allowed_cidrs | Allowed CIDR blocks | list(string) | ["0.0.0.0/0"] | no |
| enable_monitoring | Enable CloudWatch | bool | false | no |
| user_data_script | User data script | string | "" | no |
| tags | Additional tags | map(string) | {} | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_id | EC2 instance ID |
| instance_arn | EC2 instance ARN |
| public_ip | Public IP address |
| private_ip | Private IP address |
| security_group_id | Security group ID |
| availability_zone | Availability zone |

## Examples

See `../using-custom-module/` for usage example.
