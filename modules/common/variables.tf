variable "project_id" {
  description = "Project ID to deploy into"
  type        = string
}

variable "region" {
  description = "The region to deploy to"
  type        = string

  validation {
    condition     = can(regex("(europe-west1|europe-west2|us-central1)", var.region))
    error_message = "The region must be one of: europe-west1, europe-west2, us-central1."
  }
}
