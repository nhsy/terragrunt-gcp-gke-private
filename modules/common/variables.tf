variable "project_id" {
  description = "Project ID to deploy into"
  type        = string
}

variable "activate_apis" {
  description = "The list of apis to activate within the project"
  type        = list(string)
  default = [
    "compute.googleapis.com",
    "container.googleapis.com",
  ]
}
