variable "tags" {
  description = "Firewall tags"
  type        = list(any)
  default     = []
}

variable "health_check" {
  description = "Health check for mig"
  type = object({
    type                = string
    initial_delay_sec   = number
    check_interval_sec  = number
    healthy_threshold   = number
    timeout_sec         = number
    unhealthy_threshold = number
    response            = string
    proxy_header        = string
    port                = number
    request             = string
    request_path        = string
    host                = string
  })
  default = {
    "check_interval_sec" : 30,
    "healthy_threshold" : 1,
    "host" : "",
    "initial_delay_sec" : 300,
    "port" : 3128,
    "proxy_header" : "NONE",
    "request" : "",
    "request_path" : "/",
    "response" : "",
    "timeout_sec" : 10,
    "type" : "tcp",
    "unhealthy_threshold" : 5
  }
}

variable "hostname_prefix" {
  description = "Hostname prefix"
  type        = string
  default     = "proxy"
}

variable "machine_type" {
  description = "Machine type for template"
  type        = string
  default     = "e2-micro"
}

variable "network_name" {
  description = "Network self link"
  type        = string
}

variable "preemptible" {
  description = "Create preemptive forward proxy instance"
  type        = bool
  default     = false
}

variable "project_id" {
  description = "Project id"
  type        = string
}

variable "region" {
  description = "Region"
  type        = string
}

variable "service_account_name" {
  description = "Name of service account attached to forward proxy instance"
  type        = string
  default     = null
}

variable "source_image_family" {
  description = "Source image family for template"
  type        = string
  default     = "debian-10"
}

variable "source_image_project" {
  description = "Source image project"
  type        = string
  default     = "debian-cloud"
}

variable "subnet_name" {
  description = "Subnet name"
  type        = string
}

variable "template_name" {
  description = "Name of template used by mig"
  type        = string
  default     = "proxy"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = string
  default     = "10"
}

variable "unique_id" {
  description = ""
  type        = string
}

variable "zone" {
  description = ""
  type        = string
}