###
#  Enable project apis
###

module "project-services" {
  source                      = "terraform-google-modules/project-factory/google//modules/project_services"
  version                     = "~> 11.1.1"
  activate_apis               = var.activate_apis
  disable_dependent_services  = false
  disable_services_on_destroy = false
  project_id                  = var.project_id
}

