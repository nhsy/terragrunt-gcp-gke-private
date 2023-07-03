provider "tfe" {
  hostname = var.tfc_hostname
}

resource "tfe_workspace" "workspaces" {
  for_each = toset(var.tfc_workspace_names)

  name         = each.value
  organization = var.tfc_organization_name

  auto_apply = true
}

# The following variables must be set to allow runs
# to authenticate to GCP.
#
# https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable
resource "tfe_variable" "enable_gcp_provider_auth" {
  for_each     = tfe_workspace.workspaces
  workspace_id = each.value.id

  key      = "TFC_GCP_PROVIDER_AUTH"
  value    = "true"
  category = "env"

  description = "Enable the Workload Identity integration for GCP."
}

resource "tfe_variable" "tfc_gcp_project_number" {
  for_each     = tfe_workspace.workspaces
  workspace_id = each.value.id

  key      = "TFC_GCP_PROJECT_NUMBER"
  value    = data.google_project.current.number
  category = "env"

  description = "The numeric identifier of the GCP project"
}

resource "tfe_variable" "tfc_gcp_workload_pool_id" {
  for_each     = tfe_workspace.workspaces
  workspace_id = each.value.id

  key      = "TFC_GCP_WORKLOAD_POOL_ID"
  value    = google_iam_workload_identity_pool.tfc.workload_identity_pool_id
  category = "env"

  description = "The ID of the workload identity pool."
}

resource "tfe_variable" "tfc_gcp_workload_provider_id" {
  for_each     = tfe_workspace.workspaces
  workspace_id = each.value.id

  key      = "TFC_GCP_WORKLOAD_PROVIDER_ID"
  value    = google_iam_workload_identity_pool_provider.tfc.workload_identity_pool_provider_id
  category = "env"

  description = "The ID of the workload identity pool provider."
}

resource "tfe_variable" "tfc_gcp_service_account_email" {
  for_each     = tfe_workspace.workspaces
  workspace_id = each.value.id

  key      = "TFC_GCP_RUN_SERVICE_ACCOUNT_EMAIL"
  value    = google_service_account.terraform.email
  category = "env"

  description = "The GCP service account email runs will use to authenticate."
}

#resource "google_service_account_key" "terraform" {
#  service_account_id = google_service_account.terraform.name
#}

#resource "tfe_variable" "google_credentials" {
#  for_each = tfe_workspace.workspaces
#
#  workspace_id = each.value.id
#
#  key       = "GOOGLE_CREDENTIALS"
#  value     = replace(base64decode(google_service_account_key.terraform.private_key), "\n", " ")
#  category  = "env"
#  sensitive = true
#}

variable "tfc_hostname" {
  type        = string
  default     = "app.terraform.io"
  description = "The hostname of the TFC or TFE instance you'd like to use with Vault"
}

variable "tfc_organization_name" {
  type        = string
  description = "The name of your Terraform Cloud organization"
}

variable "tfc_project_name" {
  type        = string
  default     = "Default Project"
  description = "The project under which a workspace will be created"
}

variable "tfc_workspace_names" {
  type = list(string)
  default = [
    "terragrunt-gcp-gke-private-01-common",
    "terragrunt-gcp-gke-private-02-network",
    "terragrunt-gcp-gke-private-03-proxy",
    "terragrunt-gcp-gke-private-04-gke"
  ]
  description = "The name of the tfc workspaces"
}

#-----------------------------------------------------
# Creates a workload identity pool to house a workload identity
# pool provider.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool
resource "google_iam_workload_identity_pool" "tfc" {
  provider                  = google-beta
  workload_identity_pool_id = "tfc-wi"

  lifecycle {
    prevent_destroy = true
  }
}

# Creates an identity pool provider which uses an attribute condition
# to ensure that only the specified Terraform Cloud workspace will be
# able to authenticate to GCP using this provider.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/iam_workload_identity_pool_provider
resource "google_iam_workload_identity_pool_provider" "tfc" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.tfc.workload_identity_pool_id
  workload_identity_pool_provider_id = "tfc-wi"
  attribute_mapping = {
    "google.subject"                        = "assertion.sub",
    "attribute.aud"                         = "assertion.aud",
    "attribute.terraform_run_phase"         = "assertion.terraform_run_phase",
    "attribute.terraform_project_id"        = "assertion.terraform_project_id",
    "attribute.terraform_project_name"      = "assertion.terraform_project_name",
    "attribute.terraform_workspace_id"      = "assertion.terraform_workspace_id",
    "attribute.terraform_workspace_name"    = "assertion.terraform_workspace_name",
    "attribute.terraform_organization_id"   = "assertion.terraform_organization_id",
    "attribute.terraform_organization_name" = "assertion.terraform_organization_name",
    "attribute.terraform_run_id"            = "assertion.terraform_run_id",
    "attribute.terraform_full_workspace"    = "assertion.terraform_full_workspace",
  }
  oidc {
    issuer_uri = "https://${var.tfc_hostname}"
    # The default audience format used by TFC is of the form:
    # //iam.googleapis.com/projects/{project number}/locations/global/workloadIdentityPools/{pool ID}/providers/{provider ID}
    # which matches with the default accepted audience format on GCP.
    #
    # Uncomment the line below if you are specifying a custom value for the audience instead of using the default audience.
    # allowed_audiences = [var.tfc_gcp_audience]
  }
  #  attribute_condition = "assertion.sub.startsWith(\"organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:${each.value}\")"
  attribute_condition = "assertion.sub.startsWith(\"organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:workspace:terragrunt-gcp-gke-private\")"

  lifecycle {
    prevent_destroy = true
  }
}

# Allows the service account to act as a workload identity user.
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam
resource "google_service_account_iam_member" "tfc" {
  service_account_id = google_service_account.terraform.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.tfc.name}/*"

  depends_on = [
    google_iam_workload_identity_pool_provider.tfc
  ]
}
