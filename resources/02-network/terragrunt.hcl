# Include all settings from the parent terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

dependency "common" {
  config_path = "../01-common"
  mock_outputs = {
    unique_id = "abcdef"
  }
}

locals {
  common_vars = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))

  project_id        = local.common_vars.project_id
  region            = local.common_vars.region
  skip              = lookup(local.common_vars, "skip_network", false)
  subnet_name       = "snet-${local.common_vars.region}"
  subnet_cidr       = lookup(local.common_vars, "subnet_cidr", "10.0.0.0/16")
  gke_pods_cidr     = lookup(local.common_vars, "gke_pods_cidr", "10.1.0.0/16")
  gke_services_cidr = lookup(local.common_vars, "gke_services_cidr", "10.2.0.0/16")
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/network"
}

inputs = {
  firewall_custom_rules = {
    "allow-internal-mgmt-${dependency.common.outputs.unique_id}" : {
      "action" : "allow",
      "description" : "Allow internal mgmt",
      "direction" : "INGRESS",
      "extra_attributes" : {},
      "ranges" : [
        local.subnet_cidr
      ],
      "rules" : [
        {
          ports : [
            "22",
            "80",
            "443",
            "3389",
            "8080",
            "8443",
          ]
          protocol : "tcp"
        },
        {
          ports : null
          protocol : "icmp"
        },
      ],
      "sources" : null
      "targets" : null
      "use_service_accounts" : false
    },
    "allow-iap-${dependency.common.outputs.unique_id}" : {
      "action" : "allow",
      "description" : "Allow inbound connections from IAP",
      "direction" : "INGRESS",
      "extra_attributes" : {},
      "ranges" : [
        "35.235.240.0/20"
      ],
      "rules" : [
        {
          ports : ["22"],
          protocol : "tcp"
        },
        {
          ports : ["8080"],
          protocol : "tcp"
        }
      ],
      "sources" : null,
      "targets" : ["iap"],
      "use_service_accounts" : false
    },
    "allow-gke-webhooks-${dependency.common.outputs.unique_id}" : {
      "action" : "allow",
      "description" : "",
      "direction" : "INGRESS",
      "extra_attributes" : {},
      "ranges" : [
        "172.16.0.0/28"
      ],
      "rules" : [
        {
          ports : ["15017"],
          protocol : "tcp"
        }
      ],
      "sources" : null,
      "targets" : ["gke-webhooks"],
      "use_service_accounts" : false
    }
  }

  network_name    = format("%s-%s", "vpc", dependency.common.outputs.unique_id)
  project_id      = local.project_id
  region          = local.region
  router_name     = format("%s-%s", "cr-nat-router", dependency.common.outputs.unique_id)
  router_nat_name = format("%s-%s", "rn-nat-gateway", dependency.common.outputs.unique_id)
  subnets = [
    {
      subnet_name               = local.subnet_name
      subnet_ip                 = local.subnet_cidr
      subnet_region             = local.region
      subnet_private_access     = "true"
      subnet_flow_logs          = "true"
      subnet_flow_logs_interval = "INTERVAL_10_MIN"
      subnet_flow_logs_sampling = 0.7
      subnet_flow_logs_metadata = "INCLUDE_ALL_METADATA"
    }
  ]
  secondary_ranges = {
    "${local.subnet_name}" = [
      {
        range_name    = "gke-services"
        ip_cidr_range = local.gke_services_cidr
      },
      {
        range_name    = "gke-pods"
        ip_cidr_range = local.gke_pods_cidr
      }
    ]
  }
}

skip = local.skip
