# configure cluster using terraform
resource "null_resource" "kube_config"{
    depends_on = [ aws_eks_node_group.main ,aws_eks_addon.eks_addons]
    # better to provide appliaction namespace
    provisioner "local-exec" {
      command =<<EOF
        aws eks update-kubeconfig --name ${var.env}-eks-cluster
        sleep 5
        kubectl create ns roboshop
        sleep 10
        kubectl create secret generic vault-token --from-literal=token=${var.vault_token} -n roboshop

      EOF
    }#create secret on eks for storing vault-token or else copy yaml file on runner /opt/secret.yaml , kubectl apply -f /opt/secret.yaml
}
# install helm - helm provider terraform - in provoder .tf
# helm repo add external-secrets https://charts.external-secrets.io
# helm install external-secrets external-secrets/external-secrets #chartname at last
# external secrets with helm install-chart
resource "helm_release" "external_secrets" {
  depends_on = [ null_resource.kube_config ]
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets" #chartname
  namespace  = "kube-system" #admin pods or on seperate ns
  set = [{
    name  = "installCRDs"
    value = "true"
  }]
  wait       = true
  force_update=true # Terraform to upgrade/reinstall the release even if it exists
  recreate_pods    = true
  cleanup_on_fail  = true  # 🔥 Key option to prevent broken installs

 
}
#create cluster secret store
resource "null_resource" "external_cluster_secret_store" {
    depends_on = [ helm_release.external_secrets ]
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
# installing metric server if not already installed
# resource "null_resource" "metric-server" {
#     depends_on = [ null_resource.kube-config]
#     provisioner "local-exec" {
#     command = <<EOT
#       kubectl apply -f  https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
#     EOT
#   }
  
# }

#Promethus stack
# resource "helm_release" "prometheus_stack" {
#   depends_on = [ null_resource.kube_config ,helm_release.aws_loadbalancer_controller_ingress,helm_release.external_secrets,null_resource.external_cluster_secret_store]
#   name       = "prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack" #chartname
#   namespace  = "kube-system" #admin pods or on seperate ns

#   wait       = true
#   # add values files values.yaml file for reference
#   values=[
#     file("${path.module}/helm-configs/prometheus-stack.yaml")
#   ]
#   #seting host - list
#   set_list =[{
#               name = "grafana.ingress.hosts"
#               value = ["grafana-${var.env}.manupanand.online"]
#             }, {
#               name = "prometheus.ingress.hosts"
#               value = ["prometheus-${var.env}.manupanand.online"]
#             } 
#             ]
#   # add tls certificate also->annotation
#   # external dns for creating dns on run -> for aws route53
#   force_update=true # Terraform to upgrade/reinstall the release even if it exists
#   recreate_pods    = true
#   cleanup_on_fail  = true  # 🔥 Key option to prevent broken installs
#   timeout    = 600 #making uninstall time wait

# }


#kubectl get svc -n kube-system > nginxingress.yaml
# external dns for auto -create dns with route53
#helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
resource "helm_release" "external_dns" {
  depends_on = [ null_resource.kube_config ,helm_release.external_secrets,null_resource.external_cluster_secret_store]
  name       = "route53-dns"# just a chart name> pod name
  repository = "https://kubernetes-sigs.github.io/external-dns"
  chart      = "external-dns" #chartname
  namespace  = "kube-system" #admin pods or on seperate ns

  wait       = true
  force_update=true # Terraform to upgrade/reinstall the release even if it exists
  recreate_pods    = true
  cleanup_on_fail  = true  # 🔥 Key option to prevent broken installs

# by default it dont have permission- add permission iam role
 
}
#intsall cert-manager
# resource "helm_release" "cert_manager" {
#   depends_on = [ null_resource.kube_config ,helm_release.external_secrets,null_resource.external_cluster_secret_store,helm_release.external_dns]
#   name       = "cert-manager"# release-name
#   repository = "https://charts.jetstack.io"
#   chart      = "cert-manager" #chartname
#   namespace  = "kube-system" #admin pods or on seperate ns

#   wait       = true
#   force_update=true # Terraform to upgrade/reinstall the release even if it exists
#   recreate_pods    = true
#   cleanup_on_fail  = true  # 🔥 Key option to prevent broken installs

# # by default it dont have permission- add permission iam role
 
# }

# aws load balancer controller ingress
# loadbalancer - by default -classic loadbalancer installing
#kubernets-sigs.github.io/aws-load-balncer-controller/latest/deploy/installation
# resource "helm_release" "aws_loadbalancer_controller_ingress" {
#   depends_on = [ null_resource.kube_config,aws_eks_cluster.main,helm_release.external_secrets,null_resource.external_cluster_secret_store]
#   name       = "aws-ingress"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller" #chartname
#   namespace  = "kube-system" #admin pods or on seperate ns

#   wait       = true
  
#   set =[{
#             name     = "clusterName" 
#             value    = aws_eks_cluster.main.name
#           },    # need to give appropriate iam permission to pod for its SA
#           {
#           name = "vpcId" # in values.yaml vpcId to fetch
#           value= data.aws_vpc.private_vpc.id
#         }    
#         ]
# # set the http redirect to https
#   force_update=true # Terraform to upgrade/reinstall the release even if it exists
#   recreate_pods    = true
#   cleanup_on_fail  = true  # 🔥 Key option to prevent broken installs

# }

# nginx ingress - for multi ingress tags -"kubernetes.io/cluster/dev-eks-cluster"="shared"
# loadbalancer - by default -classic loadbalancer installing
# resource "helm_release" "nginx_ingress" {
#   depends_on = [ null_resource.kube_config ,aws_eks_cluster.main,helm_release.external_secrets,null_resource.external_cluster_secret_store,helm_release.aws_loadbalancer_controller_ingress]
#   name       = "ingress-nginx"
#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx" #chartname
#   namespace  = "kube-system" #admin pods or on seperate ns

#   wait       = true
  
#   values     = [ 
#          file("${path.module}/helm-configs/nginx-ingress.yaml") # will add this to yaml file of helm
#   ] 
#   force_update=true # Terraform to upgrade/reinstall the release even if it exists
#   recreate_pods    = true
#   cleanup_on_fail  = true

 
# }
# haproxy ingress loadbalancer - by default -classic loadbalancer installing
# resource "helm_release" "haproxy_ingress" {
#   depends_on = [ null_resource.kube_config ,aws_eks_cluster.main,helm_release.external_secrets,null_resource.external_cluster_secret_store,helm_release.aws_loadbalancer_controller_ingress]
#   name       = "haproxy-ingress"
#   repository = "https://haproxytech.github.io/helm-charts"
#   chart      = "kubernetes-ingress" #chartname
#   namespace  = "kube-system" #admin pods or on seperate ns

#   wait       = true
  
#   values     = [ 
#          file("${path.module}/helm-configs/haproxy-ingress.yaml") # will add this to yaml file of helm
#   ] 
#   force_update=true # Terraform to upgrade/reinstall the release even if it exists
#   recreate_pods    = true
#   cleanup_on_fail  = true

 
# }

# traefik ingress loadbalancer - by default -classic loadbalancer installing
# resource "helm_release" "traefik_ingress" {
#   depends_on = [ null_resource.kube_config ,aws_eks_cluster.main,helm_release.external_secrets,null_resource.external_cluster_secret_store,helm_release.aws_loadbalancer_controller_ingress]
#   name       = "traefik-ingress"
#   repository = "https://traefik.github.io/charts"
#   chart      = "traefik" #chartname
#   namespace  = "kube-system" #admin pods or on seperate ns

#   wait       = true
  
#   values     = [ 
#          file("${path.module}/helm-configs/traefik-ingress.yaml") # will add this to yaml file of helm
#   ] 
#   force_update=true # Terraform to upgrade/reinstall the release even if it exists
#   recreate_pods    = true
#   cleanup_on_fail  = true

 
# }
#gloo-apigateway and ingress| ingress loadbalancer - by default -classic loadbalancer installing
# resource "helm_release" "gloo_ingress" {
#   depends_on = [ null_resource.kube_config ,aws_eks_cluster.main,helm_release.external_secrets,null_resource.external_cluster_secret_store,helm_release.aws_loadbalancer_controller_ingress]
#   name       = "gloo-ingress-api"
#   repository = "https://storage.googleapis.com/solo-public-helm"
#   chart      = "gloo" #chartname
#   namespace  = "kube-system" #admin pods or on seperate ns

#   wait       = true
  
#   values     = [ 
#          file("${path.module}/helm-configs/gloo-ingress.yaml") # will add this to yaml file of helm
#   ] 
#   force_update=true # Terraform to upgrade/reinstall the release even if it exists
#   recreate_pods    = true
#   cleanup_on_fail  = true

 
# }