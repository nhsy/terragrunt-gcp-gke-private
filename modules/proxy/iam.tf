module "service-account" {
  source  = "terraform-google-modules/service-accounts/google"
  version = "4.0.2"

  count = var.service_account_name == null ? 1 : 0

  names         = [local.sa_name]
  project_id    = var.project_id
  project_roles = []
}

module "project-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "7.2.0"

  projects = [var.project_id]
  mode     = "additive"

  bindings = {
    "roles/logging.logWriter" = [
      local.sa_email_role_format,
    ]
    "roles/monitoring.metricWriter" = [
      local.sa_email_role_format,
    ]
    "roles/monitoring.viewer" = [
      local.sa_email_role_format,
    ]
    "roles/stackdriver.resourceMetadata.writer" = [
      local.sa_email_role_format,
    ]
  }

  depends_on = [module.service-account]
}
