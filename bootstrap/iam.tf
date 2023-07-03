resource "google_service_account" "terraform" {
  account_id   = "terraform"
  display_name = "Terraform Automation service account"

  depends_on = [
    google_project_service.apis
  ]
}

resource "google_project_iam_member" "terraform" {
  for_each = toset([
    "roles/compute.admin",
    "roles/container.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/iam.serviceAccountUser",
    "roles/iap.tunnelResourceAccessor",
    "roles/resourcemanager.projectIamAdmin",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin"
  ])
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.terraform.email}"
}
