## Requirements

No requirements.

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud-nat"></a> [cloud-nat](#module\_cloud-nat) | terraform-google-modules/cloud-nat/google | ~> 2.0.0 |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | terraform-google-modules/network/google//modules/fabric-net-firewall | ~> 3.4.0 |
| <a name="module_routes"></a> [routes](#module\_routes) | terraform-google-modules/network/google//modules/routes | ~> 3.4.0 |
| <a name="module_subnets"></a> [subnets](#module\_subnets) | terraform-google-modules/network/google//modules/subnets | ~> 3.4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-google-modules/network/google//modules/vpc | ~> 3.4.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_create_subnetworks"></a> [auto\_create\_subnetworks](#input\_auto\_create\_subnetworks) | When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources | `bool` | `false` | no |
| <a name="input_create_router"></a> [create\_router](#input\_create\_router) | Create router instead of using an existing one, uses 'router' variable for new resource name | `bool` | `true` | no |
| <a name="input_delete_default_internet_gateway_routes"></a> [delete\_default\_internet\_gateway\_routes](#input\_delete\_default\_internet\_gateway\_routes) | If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | An optional description of this resource. The resource must be recreated to modify this field | `string` | `null` | no |
| <a name="input_firewall_custom_rules"></a> [firewall\_custom\_rules](#input\_firewall\_custom\_rules) | List of custom rule definitions | <pre>map(object({<br>    description          = string<br>    direction            = string<br>    action               = string<br>    ranges               = list(string)<br>    sources              = list(string)<br>    targets              = list(string)<br>    use_service_accounts = bool<br>    rules = list(object({<br>      protocol = string<br>      ports    = list(string)<br>    }))<br>    extra_attributes = map(string)<br>  }))</pre> | `{}` | no |
| <a name="input_http_source_ranges"></a> [http\_source\_ranges](#input\_http\_source\_ranges) | List of IP CIDR ranges for tag-based HTTP rule | `list(string)` | `[]` | no |
| <a name="input_http_target_tags"></a> [http\_target\_tags](#input\_http\_target\_tags) | List of target tags for tag-based HTTP rule | `any` | `null` | no |
| <a name="input_https_source_ranges"></a> [https\_source\_ranges](#input\_https\_source\_ranges) | List of IP CIDR ranges for tag-based HTTPS rule | `list(string)` | `[]` | no |
| <a name="input_https_target_tags"></a> [https\_target\_tags](#input\_https\_target\_tags) | List of target tags for tag-based HTTPS rule, defaults to https-server | `list(string)` | `null` | no |
| <a name="input_log_config_enable"></a> [log\_config\_enable](#input\_log\_config\_enable) | Indicates whether or not to export logs | `bool` | `true` | no |
| <a name="input_log_config_filter"></a> [log\_config\_filter](#input\_log\_config\_filter) | Specifies the desired filtering of logs on this NAT. Valid values are: "ERRORS\_ONLY", "TRANSLATIONS\_ONLY", "ALL" | `string` | `"ALL"` | no |
| <a name="input_mtu"></a> [mtu](#input\_mtu) | The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically | `number` | `0` | no |
| <a name="input_nat_ip_allocate_option"></a> [nat\_ip\_allocate\_option](#input\_nat\_ip\_allocate\_option) | Value inferred based on nat\_ips. If present set to MANUAL\_ONLY, otherwise AUTO\_ONLY | `string` | `"false"` | no |
| <a name="input_nat_ips"></a> [nat\_ips](#input\_nat\_ips) | List of self\_links of external IPs. Changing this forces a new NAT to be created | `list(string)` | `[]` | no |
| <a name="input_network_name"></a> [network\_name](#input\_network\_name) | The name of the network being created | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Identifier of the host project where the VPC will be created | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region to deploy to | `string` | n/a | yes |
| <a name="input_router_name"></a> [router\_name](#input\_router\_name) | Router name | `string` | `"cr-nat-router"` | no |
| <a name="input_router_nat_name"></a> [router\_nat\_name](#input\_router\_nat\_name) | Name for the router NAT gateway | `string` | `"rn-nat-gateway"` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | List of routes being created in this VPC | `list(map(string))` | `[]` | no |
| <a name="input_routing_mode"></a> [routing\_mode](#input\_routing\_mode) | The network routing mode | `string` | `"REGIONAL"` | no |
| <a name="input_secondary_ranges"></a> [secondary\_ranges](#input\_secondary\_ranges) | Secondary ranges that will be used in some of the subnets | <pre>map(list(object({<br>    range_name    = string<br>    ip_cidr_range = string<br>  })))</pre> | `{}` | no |
| <a name="input_shared_vpc_host"></a> [shared\_vpc\_host](#input\_shared\_vpc\_host) | Makes this project a Shared VPC host if 'true' | `bool` | `false` | no |
| <a name="input_source_subnetwork_ip_ranges_to_nat"></a> [source\_subnetwork\_ip\_ranges\_to\_nat](#input\_source\_subnetwork\_ip\_ranges\_to\_nat) | How NAT should be configured per Subnetwork | `string` | `"ALL_SUBNETWORKS_ALL_IP_RANGES"` | no |
| <a name="input_ssh_source_ranges"></a> [ssh\_source\_ranges](#input\_ssh\_source\_ranges) | List of IP CIDR ranges for tag-based SSH rule | `list(string)` | `[]` | no |
| <a name="input_ssh_target_tags"></a> [ssh\_target\_tags](#input\_ssh\_target\_tags) | List of target tags for tag-based SSH rule | `any` | `null` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | The list of subnets being created | `list(map(string))` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_network"></a> [network](#output\_network) | The created network |
| <a name="output_network_name"></a> [network\_name](#output\_network\_name) | Name of VPC |
| <a name="output_network_self_link"></a> [network\_self\_link](#output\_network\_self\_link) | VPC network self link |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | VPC project id |
| <a name="output_route_names"></a> [route\_names](#output\_route\_names) | The route names associated with this VPC |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | A map with keys of form subnet\_region/subnet\_name and values being the outputs of the google\_compute\_subnetwork resources used to create corresponding subnets |
| <a name="output_subnets_flow_logs"></a> [subnets\_flow\_logs](#output\_subnets\_flow\_logs) | Whether the subnets will have VPC flow logs enabled |
| <a name="output_subnets_ip_cidr_ranges"></a> [subnets\_ip\_cidr\_ranges](#output\_subnets\_ip\_cidr\_ranges) | The IPs and CIDRs of the subnets being created |
| <a name="output_subnets_names"></a> [subnets\_names](#output\_subnets\_names) | The names of the subnets being created |
| <a name="output_subnets_private_access"></a> [subnets\_private\_access](#output\_subnets\_private\_access) | Whether the subnets will have access to Google API's without a public IP |
| <a name="output_subnets_regions"></a> [subnets\_regions](#output\_subnets\_regions) | The region where the subnets will be created |
| <a name="output_subnets_secondary_ranges"></a> [subnets\_secondary\_ranges](#output\_subnets\_secondary\_ranges) | The secondary ranges associated with these subnets |
| <a name="output_subnets_self_links"></a> [subnets\_self\_links](#output\_subnets\_self\_links) | The self-links of subnets being created |
