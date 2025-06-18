provider "aws" {
  region = "ap-south-2"
}
#kube config location for helm
provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}
# write helm release-infra-helm.tf