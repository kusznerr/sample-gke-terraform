terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

data "terraform_remote_state" "gke" {
  backend = "remote"

  config = {
    organization = "wabbit-dev"
    workspaces = {
      name = "wabbit-rk5-gke"
    }
  }
}

provider "kubectl" {
  host                   = data.terraform_remote_state.gke.outputs.kubernetes_endpoint
  cluster_ca_certificate = data.terraform_remote_state.gke.outputs.ca_certificat
  token                  = data.terraform_remote_state.gke.outputs.client_token
  load_config_file       = false
}

data "kubectl_file_documents" "namespace" {
    content = file("./yaml/namespace.yaml")
} 

data "kubectl_file_documents" "argocd" {
    content = file("./yaml/install.yaml")
}

data "kubectl_file_documents" "root-app" {
    content = file("./yaml/root-app.yaml")
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

resource "kubectl_manifest" "root-app" {
    depends_on = [
      kubectl_manifest.argocd,
    ]
    count     = length(data.kubectl_file_documents.root-app.documents)
    yaml_body = element(data.kubectl_file_documents.root-app.documents, count.index)
    override_namespace = "argocd"
}


# resource helm_release argocd-install {
#   name       = "argo-cd"
#   repository = "https://kusznerr.github.io/wabbit-rk5-gke-argo-apps"
#   chart      = "argo-cd"
#   version    = "1.0.4"
# }

# resource helm_release root-app {
#     depends_on = [
#       helm_release.argocd-install,
#     ]
#   name       = "root-app"
#   repository = "https://kusznerr.github.io/wabbit-rk5-gke-argo-apps"
#   chart      = "root-app"
# }