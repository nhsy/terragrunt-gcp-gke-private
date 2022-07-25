###
#  Enable project apis
###
module "project-services" {
  source  = "terraform-google-modules/project-factory/google//modules/project_services"
  version = "~> 13.0.0"

  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "iap.googleapis.com",
  ]
  disable_dependent_services  = false
  disable_services_on_destroy = false
  project_id                  = var.project_id
}

###
#  Enable project wide oslogin
###
resource "google_compute_project_metadata" "default" {
  metadata = {
    enable-oslogin = "TRUE"
  }
}