###
# Generate random string id
###

resource "random_string" "suffix" {
  length  = 5
  lower   = true
  number  = false
  special = false
  upper   = false

}

data "google_compute_zones" "available" {
  project = var.project_id
  region  = var.region
}
