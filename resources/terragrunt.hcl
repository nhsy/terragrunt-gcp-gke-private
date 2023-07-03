locals {
  common_vars = jsondecode(file("${get_parent_terragrunt_dir()}/common_vars.json"))
}

remote_state {
  backend = "gcs"

  config = {
    bucket               = get_env("TG_BUCKET")
    prefix               = "terragrunt-gcp-gke-private/${path_relative_to_include()}"
    skip_bucket_creation = true
  }
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "gcs" {}
}
EOF
}

# Uncomment to enable terraform cloud backend
#generate "backend" {
#  path      = "backend.tf"
#  if_exists = "overwrite"
#  contents  = <<EOF
#terraform {
#  cloud {
#    organization = "${local.common_vars.tfc_org}"
#    workspaces {
#      name = "terragrunt-gcp-gke-private-${path_relative_to_include()}"
#    }
#  }
#}
#EOF
#}

generate "providers" {
  path      = "providers.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}
EOF
}

generate "versions" {
  path      = "versions.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = ">=1.2.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.29.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.29.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      #version = "~> 3.0"
    }
  }
}
EOF
}

terraform {
  before_hook "tfsec" {
    commands = ["apply", "plan"]
    execute  = ["tfsec", "--config-file", "${get_parent_terragrunt_dir()}/tfsec.yml"]
  }
}
