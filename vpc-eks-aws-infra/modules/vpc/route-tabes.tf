resource "aws_route_table" "public_subnets" {
  depends_on = [ aws_vpc.private ]
  count      = length(var.public_subnets)
  vpc_id     = aws_vpc.private.id


  # route associate for internet gate way
  route {
    cidr_block =  "0.0.0.0/0"
    gateway_id = aws_internet_gateway.private_vpc_igw.id 
  }

  # attch peering connection 
  route{
    cidr_block                  =  var.default_vpc_cidr
    vpc_peering_connection_id   =  aws_vpc_peering_connection.default_private_peering.id
  }

  tags={
    Name="${var.env}-pblc-sbnt-rt-${var.availability_zones[count.index]}"
  }
}
resource "aws_route_table" "kube_subnets" {
   depends_on = [ aws_vpc.private ]
   count      = length(var.kube_subnets)
   vpc_id     = aws_vpc.private.id


  # attach route nat gateway
  route{
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.public_subnet_ntgw.*.id[count.index]
  }

  # attch peering connection 
  route{
    cidr_block                  =  var.default_vpc_cidr
    vpc_peering_connection_id   =  aws_vpc_peering_connection.default_private_peering.id
  }


  tags={
    Name="${var.env}-kube-sbnt-rt-${var.availability_zones[count.index]}"
  }
}
resource "aws_route_table" "db_subnets" {
   depends_on = [ aws_vpc.private ]
   count      = length(var.db_subnets) 
  vpc_id      = aws_vpc.private.id


  # attach route nat gateway
  route{
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.public_subnet_ntgw.*.id[count.index]
  }

  # attch peering connection 
  route{
    cidr_block                  =  var.default_vpc_cidr
    vpc_peering_connection_id   =  aws_vpc_peering_connection.default_private_peering.id
  }

  tags={
    Name="${var.env}-db-sbnt-rt-${var.availability_zones[count.index]}"
  }
}
# associate route tables with subnets
resource "aws_route_table_association" "public_subnets_asso" {
    depends_on        = [ aws_route_table.public_subnets ]
    count             = length(var.public_subnets)
    subnet_id         = aws_subnet.public_subnets.*.id[count.index] 
    route_table_id    = aws_route_table.public_subnets.*.id[count.index] 

   
}
resource "aws_route_table_association" "kube_subnets_asso" {
    depends_on        = [ aws_route_table.kube_subnets ]
    count             = length(var.kube_subnets)
    subnet_id         = aws_subnet.kube_subnets.*.id[count.index] 
    route_table_id    = aws_route_table.kube_subnets.*.id[count.index] 

   
}
resource "aws_route_table_association" "db_subnets_asso" {
    depends_on        = [ aws_route_table.db_subnets ]
    count             = length(var.db_subnets)
    subnet_id         = aws_subnet.db_subnets.*.id[count.index] 
    route_table_id    = aws_route_table.db_subnets.*.id[count.index] 

   
}