output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "zones" {
  value       = var.zones
  description = "Node Zones"
}

output "cluster_name" {
  description = "Cluster name"
  value       = module.gke.name
}

output "kubernetes_endpoint" {
  sensitive = true
  value     = module.gke_auth.host
}

output "client_token" {
  sensitive = true
  value     = module.gke_auth.token
}

output "ca_certificate" {
  value = module.gke_auth.cluster_ca_certificate
}

output "kubeconfig_raw" {
  value = module.gke_auth.kubeconfig_raw
}

output "service_account" {
  description = "The default service account used for running nodes."
  value       = module.gke.service_account
}