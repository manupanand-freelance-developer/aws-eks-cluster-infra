# configure cluster using terraform
resource "null_resource" "kube-config"{
    depends_on = [ aws_eks_node_group.main ]
    provisioner "local-exec" {
      command =<<EOF
        aws eks update-kubeconfig --name ${var.env}-eks-cluster
        sleep 10
        kubectl create secret generic vault-token --from-literal=token=${var.vault_token} -n kube-system

      EOF
    }#create secret on eks for storing vault-token or else copy yaml file on runner /opt/secret.yaml , kubectl apply -f /opt/secret.yaml
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
  set {
    name  = "installCRDs"
    value = "true"
  }
  wait       = true
  

 
}
#create cluster secret store
resource "null_resource" "external-secret-store" {
    depends_on = [ helm_release.external-secrets ]
    provisioner "local-exec" {
    command = <<EOT
      # Wait for CRD to be registered
      echo "Waiting for ClusterSecretStore CRD to be available..."
      for i in {1..30}; do
        kubectl get crd clustersecretstores.external-secrets.io && break
        echo "CRD not ready yet. Retrying in 5s..."
        sleep 5
      done

      # Now apply the manifest
      kubectl apply -f modules/eks/vault-secretstore.yaml
    EOT
  }
  
}