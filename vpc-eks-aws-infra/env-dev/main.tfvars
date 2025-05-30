env="dev"

vpc={
    cidr_block          =   "10.10.0.0/16"
    public_subnets      =   ["10.10.0.0/20","10.10.16.0/20","10.10.32.0/20"]
    kube_subnets        =   ["10.10.64.0/20","10.10.80.0/20","10.10.96.0/20"]
    db_subnets          =   ["10.10.128.0/20","10.10.144.0/20","10.10.160.0/20"]
     # providing the default vpc details for peering
    default_vpc_id      =   "vpc-0a814be354897a863"
    default_vpc_rt      =   "rtb-0cf04062d48dae201"
    default_vpc_cidr    =  "172.31.0.0/16"
    availability_zones  =  ["ap-south-2a","ap-south-2b","ap-south-2c"]
}