# Production Environment Variables
# Usage: terraform apply -var-file="prod.tfvars"

environment       = "prod"
aws_region        = "us-west-2"
instance_type     = "t3.medium"
instance_count    = 3
enable_monitoring = true

allowed_ssh_cidrs = [
  "10.0.0.0/8" # VPN CIDR only
]

tags = {
  Team       = "platform"
  CostCenter = "engineering"
  Project    = "terraform-tutorial"
  Backup     = "daily"
}

server_config = {
  instance_type = "t3.medium"
  volume_size   = 100
  volume_type   = "gp3"
}

# Set this via environment variable or secret manager:
# export TF_VAR_db_password="$(aws secretsmanager get-secret-value --secret-id prod/db/password --query SecretString --output text)"
