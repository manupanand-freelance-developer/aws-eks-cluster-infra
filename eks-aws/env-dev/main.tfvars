# vpc
env="dev"
vpc_name     ="dev-private-vpc"
subnet_name_2a  ="dev-kbe-sbnt-ap-south-2a"
subnet_name_2b  ="dev-kbe-sbnt-ap-south-2b" 
subnet_name_2c  ="dev-kbe-sbnt-ap-south-2c"     
  
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
}
 