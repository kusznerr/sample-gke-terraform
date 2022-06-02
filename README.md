# sample-gke-terraform
sample gke cluster for play and fun. 

## Setting up argoCD
As an option, there is a possibility to add in ArgoCD /w app-of-apps pattern. Please see separate deployment instructions under `argo` folder. 

# Simple Regional Cluster

Simple GKE cluster with output of `kubeconfig`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_name\_suffix | A suffix to append to the default cluster name | `string` | `""` | no |
| compute\_engine\_service\_account | Service account to associate to the nodes in the cluster | `any` | n/a | yes |
| ip\_range\_pods | The secondary ip range to use for pods | `any` | n/a | yes |
| ip\_range\_services | The secondary ip range to use for services | `any` | n/a | yes |
| network | The VPC network to host the cluster in | `any` | n/a | yes |
| project\_id | The project ID to host the cluster in | `any` | n/a | yes |
| region | The region to host the cluster in | `any` | n/a | yes |
| skip\_provisioners | Flag to skip local-exec provisioners | `bool` | `false` | no |
| subnetwork | The subnetwork to host the cluster in | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | n/a |
| client\_token | n/a |
| cluster\_name | Cluster name |
| ip\_range\_pods | The secondary IP range used for pods |
| ip\_range\_services | The secondary IP range used for services |
| kubeconfig\_raw | n/a |
| kubernetes\_endpoint | n/a |
| location | n/a |
| master\_kubernetes\_version | The master Kubernetes version |
| network | n/a |
| project\_id | n/a |
| region | n/a |
| service\_account | The default service account used for running nodes. |
| subnetwork | n/a |
| zones | List of zones in which the cluster resides |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `gcloud auth application-default login --project [gcp-project-name]  ` to set the google context
Reference material [here](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/using_gke_with_terraform)
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

To use the cluster from kubectl do following:
- `gcloud container clusters get-credentials CLUSTER_NAME` add in new context in your $home/.kube/config
Reference material [here](https://cloud.google.com/kubernetes-engine/docs/how-to/cluster-access-for-kubectl)
