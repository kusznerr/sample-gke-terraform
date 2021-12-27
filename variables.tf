variable "GOOGLE_CREDENTIALS" {
  description = "Credentials set in TFE workspace"
  default="xxx"
}

variable "project_id" {
  description = "your_project_id"
  default= "wabbit-rk5"
}

variable "region" {
  description = "The region to host the cluster in"
  default     = "europe-west4"
}

variable "zones" {
  description = "The region to host the cluster in"
  default     = ["europe-west4-a"]
}

variable "cluster_name" {
  description = "The name for the GKE cluster"
  default     = "rafal-gke"
}

variable "env_name" {
  description = "The environment for the GKE cluster"
  default     = "prod"
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
