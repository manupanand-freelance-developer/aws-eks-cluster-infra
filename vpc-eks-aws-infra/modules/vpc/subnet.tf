# subnets for vpc
resource "aws_subnet" "public_subnets" {
  count             =   length(var.public_subnets) 
  vpc_id            =   aws_vpc.private.id 
  cidr_block        =   var.public_subnets[count.index]
  availability_zone =  var.availability_zones[count.index] 

  tags={
    Name="${var.env}-pbl-sbnt-${var.availability_zones[count.index]}"
    "kubernetes.io/cluster/dev-eks-cluster"="shared"# tag for eks to identify and create load balncer
    "kubernetes.io/role/elb"=1 # for public load balancer
  } 
}
resource "aws_subnet" "kube_subnets" {
  count             =   length(var.kube_subnets) 
  vpc_id            =   aws_vpc.private.id 
  cidr_block        =   var.kube_subnets[count.index]
  availability_zone =  var.availability_zones[count.index] 


  tags={
    Name="${var.env}-kbe-sbnt-${var.availability_zones[count.index]}"
    "kubernetes.io/cluster/dev-eks-cluster"="shared"
    "kubernetes.io/role/internal-elb"= 1
  } 
}
resource "aws_subnet" "db_subnets" {
  count             =   length(var.db_subnets) 
  vpc_id            =   aws_vpc.private.id 
  cidr_block        =   var.db_subnets[count.index]
  availability_zone =  var.availability_zones[count.index] 


  tags={
    Name="${var.env}-db-sbnt-${var.availability_zones[count.index]}"
    "kubernetes.io/cluster/dev-eks-cluster"="shared" #shared for multi ingress only one -owned
    "kubernets.io/role/internal-elb"= 1 # for private -tag to create private load balancer 
  } 
}