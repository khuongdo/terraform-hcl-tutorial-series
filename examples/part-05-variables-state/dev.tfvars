# Development Environment Variables
# Usage: terraform apply -var-file="dev.tfvars"

environment       = "dev"
aws_region        = "us-west-2"
instance_type     = "t2.micro"
instance_count    = 1
enable_monitoring = false

allowed_ssh_cidrs = [
  "203.0.113.0/24" # Replace with your office IP range
]

tags = {
  Team       = "platform"
  CostCenter = "engineering"
  Project    = "terraform-tutorial"
}

server_config = {
  instance_type = "t2.micro"
  volume_size   = 20
  volume_type   = "gp3"
}

# Set this via environment variable instead:
# export TF_VAR_db_password="your-secure-password-here"
# db_password = "NEVER_HARDCODE_PASSWORDS"
