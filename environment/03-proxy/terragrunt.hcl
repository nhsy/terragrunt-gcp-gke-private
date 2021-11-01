# Include all settings from the parent terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "common" {
  config_path = "../01-common"
  mock_outputs = {
    unique_id = "abcdef",
    zone      = "europe-west1-b",
    zones     = ["europe-west1-b"],
  }
}

dependency "network" {
  config_path = "../02-network"
  mock_outputs = {
    network_name  = "network_name",
    subnets_names = ["subnets_name"],
  }
}

locals {
  common_vars = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))
  preemptible = lookup(local.common_vars, "preemptible", true)
  skip        = lookup(local.common_vars, "skip_proxy", false)
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/proxy"
}

inputs = {
  network_name = dependency.network.outputs.network_name
  preemptible  = local.preemptible
  project_id   = local.common_vars.project_id
  region       = local.common_vars.region
  subnet_name  = dependency.network.outputs.subnets_names[0]
  tags = [
    "iap",
  ]
  unique_id = dependency.common.outputs.unique_id
  zone      = dependency.common.outputs.zone
}

skip = local.skip