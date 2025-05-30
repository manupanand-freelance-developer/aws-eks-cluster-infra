# subnets for vpc
resource "aws_subnet" "public_subnets" {
  count             =   length(var.public_subnets) 
  vpc_id            =   aws_vpc.private.id 
  cidr_block        =   var.public_subnets[count.index]
  availability_zone =  var.availability_zones[count.index] 

  tags={
    Name="${var.env}-pbl-sbnt-${var.availability_zones[count.index]}"
  } 
}
resource "aws_subnet" "kube_subnets" {
  count             =   length(var.kube_subnets) 
  vpc_id            =   aws_vpc.private.id 
  cidr_block        =   var.kube_subnets[count.index]
  availability_zone =  var.availability_zones[count.index] 


  tags={
    Name="${var.env}-kbe-sbnt-${var.availability_zones[count.index]}"
  } 
}
resource "aws_subnet" "db_subnets" {
  count             =   length(var.db_subnets) 
  vpc_id            =   aws_vpc.private.id 
  cidr_block        =   var.db_subnets[count.index]
  availability_zone =  var.availability_zones[count.index] 


  tags={
    Name="${var.env}-db-sbnt-${var.availability_zones[count.index]}"
  } 
}