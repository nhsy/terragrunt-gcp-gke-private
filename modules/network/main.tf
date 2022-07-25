###
# Create vpc network
###

module "vpc" {
  source = "terraform-google-modules/network/google//modules/vpc"

  version                                = "~> 5.1.0"
  auto_create_subnetworks                = var.auto_create_subnetworks
  delete_default_internet_gateway_routes = var.delete_default_internet_gateway_routes
  description                            = var.description
  network_name                           = var.network_name
  project_id                             = var.project_id
  routing_mode                           = var.routing_mode
  shared_vpc_host                        = var.shared_vpc_host
}

###
# Create subnets
###

module "subnets" {
  source  = "terraform-google-modules/network/google//modules/subnets"
  version = "~> 5.1.0"

  network_name     = module.vpc.network_name
  project_id       = var.project_id
  secondary_ranges = var.secondary_ranges
  subnets          = var.subnets
}

###
# Create routes
###

module "routes" {
  source  = "terraform-google-modules/network/google//modules/routes"
  version = "~> 5.1.0"

  module_depends_on = [module.subnets.subnets]
  network_name      = module.vpc.network_name
  project_id        = var.project_id
  routes            = var.routes
}

###
# Create firewall rules
###

module "firewall" {
  source  = "terraform-google-modules/network/google//modules/fabric-net-firewall"
  version = "~> 5.1.0"

  custom_rules       = var.firewall_custom_rules
  http_source_ranges = var.https_source_ranges
  #http_target_tags    = var.https_target_tags
  https_source_ranges = var.https_source_ranges
  https_target_tags   = var.http_target_tags
  network             = module.vpc.network_name
  project_id          = var.project_id
  ssh_source_ranges   = var.ssh_source_ranges
  ssh_target_tags     = var.ssh_target_tags
}

###
# Create cloud router
###

module "cloud-router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 3.0.0"

  name    = var.router_name
  network = module.vpc.network_self_link
  project = var.project_id
  region  = var.region

  nats = [
    {
      #log_config_enable                  = var.log_config_enable
      #log_config_filter                  = var.log_config_filter
      name = var.router_nat_name
      #nat_ip_allocate_option             = var.nat_ip_allocate_option
      #nat_ips                            = var.nat_ips
      project = var.project_id
      router  = module.cloud-router.router.name
      region  = var.region
      #source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
    }
  ]

}
