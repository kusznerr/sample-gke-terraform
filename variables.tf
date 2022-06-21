variable "GOOGLE_CREDENTIALS" {
  description = "Credentials set in TFE workspace"
  default="C:/GCP_TERRAFORM_KEY/key.json"
}

variable "project_id" {
  description = "your_project_id"
  default= "spring-banner-353911"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "us-central1"
}

variable "zones" {
  description = "The region to host the cluster in"
  default     = ["us-central1-a"]
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "test-gke"
}

variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "test"
}
variable "network" {
  description = "The VPC network created to host the cluster in"
  default     = "gke-network"
}

variable "subnetwork" {
  description = "The subnetwork created to host the cluster in"
  default     = "gke-subnet"
}

variable "subnetwork_ipv4_cidr_range" {
  description = "The subnetwork ip cidr block range."
  default     = "10.20.0.0/14"
}

variable "ip_range_pods_name" {
  description = "The secondary ip range to use for pods"
  default     = "ip-range-pods"
}

variable "pod_ipv4_cidr_range" {
  description = "The cidr ip range to use for pods"
  default     = "10.24.0.0/14"
}

variable "ip_range_services_name" {
  description = "The secondary ip range name to use for services"
  default     = "ip-range-services"
}
variable "services_ipv4_cidr_range" {
  description = "The cidr ip range to use for services"
  default     = "10.28.0.0/20"
}
