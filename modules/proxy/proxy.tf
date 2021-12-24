module "instance-template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "7.1.0"

  disk_size_gb = var.disk_size_gb
  machine_type = var.machine_type
  name_prefix  = var.template_name
  #network              = var.network_name
  preemptible = var.preemptible
  #project_id           = var.project_id
  service_account      = local.service_account_object
  source_image_family  = var.source_image_family
  source_image_project = var.source_image_project
  startup_script       = file("${path.module}/files/metadata-startup.sh")
  subnetwork           = var.subnet_name
  subnetwork_project   = var.project_id
  tags                 = var.tags

  depends_on = [module.service-account]
}

module "compute-instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "7.1.0"

  hostname          = format("%s-%s", var.hostname_prefix, var.unique_id)
  instance_template = module.instance-template.self_link
  #region             = var.region
  subnetwork         = var.subnet_name
  subnetwork_project = var.project_id
  zone               = var.zone

  depends_on = [module.service-account]
}
