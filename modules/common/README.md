## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_project-services"></a> [project-services](#module\_project-services) | terraform-google-modules/project-factory/google//modules/project_services | ~> 11.1.1 |

## Resources

| Name | Type |
|------|------|
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | The list of apis to activate within the project | `list(string)` | <pre>[<br>  "compute.googleapis.com",<br>  "container.googleapis.com"<br>]</pre> | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Project ID to deploy into | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_unique_id"></a> [unique\_id](#output\_unique\_id) | n/a |
