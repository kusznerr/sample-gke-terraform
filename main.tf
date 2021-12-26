terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.0.3"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      version = "1.13.1"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

module "gke_auth" {
  source = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on   = [module.gke]
  project_id   = var.project_id
  location     = module.gke.location
  cluster_name = module.gke.name
}
resource "local_file" "kubeconfig" {
  content  = module.gke_auth.kubeconfig_raw
  filename = "kubeconfig-${var.env_name}-${timestamp()}"
}

module "gcp-network" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = "${var.network}-${var.env_name}"
  subnets = [
    {
      subnet_name   = "${var.subnetwork}-${var.env_name}"
      subnet_ip     = "10.10.0.0/16"
      subnet_region = var.region
    },
  ]
  secondary_ranges = {
    "${var.subnetwork}-${var.env_name}" = [
      {
        range_name    = var.ip_range_pods_name
        ip_cidr_range = "10.20.0.0/16"
      },
      {
        range_name    = var.ip_range_services_name
        ip_cidr_range = "10.30.0.0/16"
      },
    ]
  }
}

module "gke" {
  source                      = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                  = var.project_id
  name                        = "${var.cluster_name}-${var.env_name}"
  regional                    = true
  region                      = var.region
  zones                       = var.zones
  network                     = module.gcp-network.network_name
  subnetwork                  = module.gcp-network.subnets_names[0]
  ip_range_pods               = var.ip_range_pods_name
  ip_range_services           = var.ip_range_services_name
  http_load_balancing         = true
  horizontal_pod_autoscaling  = true
  network_policy              = true
  remove_default_node_pool    = true
  release_channel             = "RAPID"
  kubernetes_version          = "latest"
  node_pools = [
    {
      name                  = "regional-pool"
      preeptible            = false
      machine_type          = "e2-medium"
      image_type            = "UBUNTU"
      disk_type             = "pd-balanced"
      disk_size_gb          = 30
      local_ssd_count       = 0
      tags                  = "gke-node"
      min_count             = 1
      max_count             = 2
      max_surge             = 2
      max_unavailable       = 1
      autoscaling           = true
      auto_upgrade          = true
      auto_repair           = true
      node_metadata         = "GKE_METADATA_SERVER"
    },
  ]
  node_pools_oauth_scopes = {
    all = []

    regional-pool = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
    ]
  }

  node_pools_labels = {
    all = {}

    default-node-pool = {
      default-pool = true
    }
  }

  node_pools_tags = {
    all = []

    default-pool = [
     "gke-node", "${var.project_id}-gke"
    ]
  }
}

provider "helm" {
  kubernetes {
    host  = module.gke_auth.host
    token = module.gke_auth.token
    cluster_ca_certificate = module.gke_auth.cluster_ca_certificate
  }
}

resource helm_release argocd-install {
  name       = "argocd-apps"
  repository = "https://github.com/kusznerr/wabbit-rk5-gke-argo-apps/"
  chart      = "argo-cd"
}

resource helm_release root-app {
  name       = "root-app"
  repository = "https://github.com/kusznerr/wabbit-rk5-gke-argo-apps/"
  chart      = "root"
}

/*
// Enable ArgoCD server
// Any changes to this configuration ie. destroy / refresh throws terraform errors
// Moved to helm release for ArgoCD as well as root application as outlined above

provider "kubectl" {
  host                   = module.gke_auth.host
  cluster_ca_certificate = base64decode(module.gke_auth.cluster_ca_certificate)
  token                  = module.gke_auth.token
  load_config_file       = false
}

data "kubectl_file_documents" "namespace" {
    content = file("./manifests/argocd/namespace.yaml")
} 

data "kubectl_file_documents" "argocd" {
    content = file("./manifests/argocd/install.yaml")
}

data "kubectl_file_documents" "apps" {
    content = file("./manifests/argocd/apps.yaml")
}

resource "kubectl_manifest" "namespace" {
    count     = length(data.kubectl_file_documents.namespace.documents)
    yaml_body = element(data.kubectl_file_documents.namespace.documents, count.index)
    override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd" {
    depends_on = [
      kubectl_manifest.namespace,
    ]
    count     = length(data.kubectl_file_documents.argocd.documents)
    yaml_body = element(data.kubectl_file_documents.argocd.documents, count.index)
    override_namespace = "argocd"
}

resource "kubectl_manifest" "apps" {
    depends_on = [
      kubectl_manifest.argocd,
    ]
    count     = length(data.kubectl_file_documents.apps.documents)
    yaml_body = element(data.kubectl_file_documents.apps.documents, count.index)
    override_namespace = "argocd"
}

*/