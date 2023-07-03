resource "google_storage_bucket" "terraform_state" {
  location = var.region
  name     = "terraform-state-${data.google_project.current.number}"

  force_destroy               = true
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}
