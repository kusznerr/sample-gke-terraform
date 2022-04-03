terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

/* Remote backend for TFE 
data "terraform_remote_state" "gke" {
  backend = "remote"

  config = {
    organization = var.tfe_org
    workspaces = {
      name = var.tfe_workspace
    }
  }
}
*/

/* Remote backend for local terraform execution */
data "terraform_remote_state" "gke" {
  backend = "local"
  config = {
    path = "../terraform.tfstate"
  }
}


provider "kubectl" {
  host                   = data.terraform_remote_state.gke.outputs.kubernetes_endpoint
  cluster_ca_certificate = data.terraform_remote_state.gke.outputs.ca_certificate
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