resource "google_project_service" "apis" {
  for_each = toset([
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "sts.googleapis.com"
  ])

  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = false
}