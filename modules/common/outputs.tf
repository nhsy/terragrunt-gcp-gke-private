output "project_id" {
  value = var.project_id
}

output "region" {
  value = var.region
}

output "unique_id" {
  value = random_string.suffix.result
}

output "zone" {
  value = data.google_compute_zones.available.names[0]
}

output "zones" {
  value = data.google_compute_zones.available.names
}
