output "project_id" {
  description = "VPC project id"
  value       = module.vpc.project_id
}

output "network" {
  description = "The created network"
  value       = module.vpc
}

output "network_name" {
  description = "Name of VPC"
  value       = module.vpc.network_name
}

output "network_self_link" {
  description = "VPC network self link"
  value       = module.vpc.network_self_link
}

output "subnets" {
  description = "A map with keys of form subnet_region/subnet_name and values being the outputs of the google_compute_subnetwork resources used to create corresponding subnets"
  value       = module.subnets.subnets
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = [for network in module.subnets.subnets : network.name]
}

output "subnets_ip_cidr_ranges" {
  description = "The IPs and CIDRs of the subnets being created"
  value       = [for network in module.subnets.subnets : network.ip_cidr_range]
}

output "subnets_self_links" {
  description = "The self-links of subnets being created"
  value       = [for network in module.subnets.subnets : network.self_link]
}

output "subnets_regions" {
  description = "The region where the subnets will be created"
  value       = [for network in module.subnets.subnets : network.region]
}

output "subnets_private_access" {
  description = "Whether the subnets will have access to Google API's without a public IP"
  value       = [for network in module.subnets.subnets : network.private_ip_google_access]
}

output "subnets_flow_logs" {
  description = "Whether the subnets will have VPC flow logs enabled"
  value       = [for network in module.subnets.subnets : length(network.log_config) != 0 ? true : false]
}

output "subnets_secondary_ranges" {
  description = "The secondary ranges associated with these subnets"
  value       = [for network in module.subnets.subnets : network.secondary_ip_range]
}

output "route_names" {
  description = "The route names associated with this VPC"
  value       = [for route in module.routes.routes : route.name]
}