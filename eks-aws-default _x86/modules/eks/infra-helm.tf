# configure cluster using terraform
resource "null_resource" "kube-config"{
    depends_on = [ aws_eks_node_group.main ]
    provisioner "local-exec" {
      command =<<EOF
        aws eks update-kubeconfig --name ${var.env}-eks-cluster
        sleep 10
        kubectl create generic vault-token --from-literal=token=${var.vault_token} -n kube-system

      EOF
    }
}
# install helm - helm provider terraform - in provoder .tf
# helm repo add external-secrets https://charts.external-secrets.io
# helm install external-secrets external-secrets/external-secrets #chartname at last
# external secrets with helm install-chart
resource "helm_release" "external-secrets" {
  depends_on = [ null_resource.kube-config ]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets" #chartname
  namespace  = "kube-system" #admin pods or on seperate ns
  wait       = true
 
}
#create secret on eks for storing vault-token
resource "null_resource" "external-secret-store" {
    depends_on = [ helm_release.external-secrets ]
    provisioner "local-exec" {
      command = <<EOF
      EOF
    }
  
}