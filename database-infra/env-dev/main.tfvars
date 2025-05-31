env             ="dev"
vpc_name        ="dev-private-vpc"
subnet_name     ={
                    subnet_name_a     ="dev-db-sbnt-ap-south-2a"
                    subnet_name_b     ="dev-db-sbnt-ap-south-2b"
                    subnet_name_c     ="dev-db-sbnt-ap-south-2c"
                    }
ami_id          ="ami-0e86c549c4c958e98"
zone_id         ="Z02556032JV56RSCGA16T"



ec2_instance={
    grafana={
        instance_type ="t3.medium"
        volume_size   =30
        policy_name=["AmazonEC2FullAccess","AmazonSSMFullAccess","AmazonS3ReadOnlyAccess"]
        server_port={
                ssh={
                    port="22"
                }
                  grafana={
                    port="3000"
                }
                 http={
                    port="80"
                }
                 https={
                    port="443"
                }
            }
    }
}