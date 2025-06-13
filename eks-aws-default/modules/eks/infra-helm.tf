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
  wait       = true

 
}
#create cluster secret store
resource "null_resource" "external-secret-store" {
    depends_on = [ helm_release.external-secrets ]
    provisioner "local-exec" {
      command = <<EOF
            kubectl apply -f - <<EOK
                                apiVersion: external-secrets.io/v1beta1
                                kind: ClusterSecretStore 
                                metadata: 
                                    name: vault-backend  
                                spec: 
                                    provider: 
                                        vault: 
                                            server: "http://vault-public.manupanand.online:8200"  
                                            path: "roboshop-k8s"
                                            version: "v2"  
                                            auth: 
                                                tokenSecretRef: 
                                                    name: "vault-token"
                                                    key: "token" 
                                                    namespace: kube-system

            EOK
      EOF
    }
  
}