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
  }
}


resource helm_release argocd-install {
  name       = "argocd-apps"
  repository = "https://kusznerr.github.io/wabbit-rk5-gke-argo-apps"
  chart      = "argo-cd"
}

resource helm_release root-app {
    depends_on = [
      helm_release.argocd-install,
    ]
  name       = "root-app"
  repository = "https://kusznerr.github.io/wabbit-rk5-gke-argo-apps"
  chart      = "root-app"
}
