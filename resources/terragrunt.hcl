remote_state {
  backend = "gcs"

  config = {
    bucket               = get_env("TG_BUCKET")
    prefix               = "gcp-terragrunt-gke-private/${path_relative_to_include()}"
    skip_bucket_creation = false
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
  required_version = ">=1.0.4"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.80.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.80.0"
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