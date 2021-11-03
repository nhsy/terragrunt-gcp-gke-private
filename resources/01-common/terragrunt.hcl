# Include all settings from the parent terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  common_vars = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))
  skip        = lookup(local.common_vars, "skip_common", false)
}

terraform {
  source = "${get_parent_terragrunt_dir()}/..//modules/common"
}

inputs = {
  project_id = local.common_vars.project_id
  region     = local.common_vars.region
}

skip = local.skip
