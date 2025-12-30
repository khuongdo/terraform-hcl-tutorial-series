# Outputs from Module Usage

output "dev_server_ip" {
  description = "Dev server public IP"
  value       = module.dev_server.public_ip
}

output "dev_server_id" {
  description = "Dev server instance ID"
  value       = module.dev_server.instance_id
}

output "prod_server_ip" {
  description = "Prod server public IP"
  value       = module.prod_server.public_ip
}

output "prod_server_id" {
  description = "Prod server instance ID"
  value       = module.prod_server.instance_id
}
