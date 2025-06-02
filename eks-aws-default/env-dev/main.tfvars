# vpc
env="dev"
vpc_name     ="default_vpc_south2"
subnet_name_2a  ="default-ap-south-2a"
subnet_name_2b  ="default-ap-south-2b" 
subnet_name_2c  ="default-ap-south-2c"     
  
#eks

eks={
    eks_version  = "1.33" 
    node_groups={
        
        main_spot={
            instance_types      =["t4g.medium"]#c7g.large
            max_size            = 3
            min_size            = 1 
            capacity_type       = "SPOT"
            ami_type            ="AL2023_ARM_64_STANDARD"
        }
    }
    # aws eks describe-addon-versions command |grep addonName
    add_ons={
        vpc-cni="v1.19.5-eksbuild.3"
        
        metrics-server="v0.7.2-eksbuild.3"
       
        kube-proxy="v1.33.0-eksbuild.2"
        
        coredns="v1.12.1-eksbuild.2"
        eks-pod-identity-agent="v1.3.7-eksbuild.2"
        aws-ebs-csi-driver="v1.44.0-eksbuild.1"
        metrics-server="v0.7.2-eksbuild.3"
        #aws-guardduty-agent="v1.10.0-eksbuild.2"
        cert-manager="v1.17.2-eksbuild.1"
        #amazon-cloudwatch-observability="v4.0.1-eksbuild.1"
        
    }
    eks-iam-access ={
        workstation={
            kubernetes_groups = []
            bastion_role_arn ="arn:aws:iam::058264470882:role/workstation-devops"
            bastion_policy ="arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        }
        vault-server={
            kubernetes_groups = []
            bastion_role_arn ="arn:aws:iam::058264470882:role/vault-role"
            bastion_policy ="arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        }
# grunner will be already provisoned
        
        #   sso_users={
        #     kubernetes_groups = []
        #     bastion_role_arn ="ssogrouparn"
        #     bastion_policy ="arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
        # }
    }

}