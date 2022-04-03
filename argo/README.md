# ArgoCD deployment using terraform
Installing aargoCD to already provisioned cluster. 

See my GKE /w Terraform tutorial - Step4 : [here]('https://medium.com/aws-tip/setting-up-gke-with-terraform-cloud-bf9dfb5d1c8b')

# Important notes
## Terraform backends
Two modes are considered here, and are dependent on how the GKE cluster was provisioned. Terraform CLI or via Terraform Cloud. 
- TFE as remote backend
- Local 
Select required option by amending `main.tf`. Local execution is selected as default. 

## Root application
`yaml\root-app` defines the app-of-apps patterns for ArgoCD. You should create a separate repo similar to this, to manage your application deployments for you GKE cluster. For now coordinates for repo/folder-to-watch are removed from the yaml file to avoid accidental application deployment. 

As per tutorial - for the app-of-apps pattern to work, suggest to use Terraform Cloud for auto-updates of newly created app. 