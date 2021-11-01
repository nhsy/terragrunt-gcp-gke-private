output "proxy_name" {
  description = "Name of forward proxy instance"
  value       = module.compute-instance.instances_details[0].name
}

output "proxy_zone" {
  description = "Name of forward proxy instance"
  value       = module.compute-instance.instances_details[0].zone
}
