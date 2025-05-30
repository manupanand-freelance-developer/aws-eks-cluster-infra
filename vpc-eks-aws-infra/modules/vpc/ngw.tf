# eastic ip 
 resource "aws_eip" "private_vpc_nat_ip" {
  count       = length(var.availability_zones)
   domain     ="vpc"
 }


# nat gate way
resource "aws_nat_gateway" "public_subnet_ntgw" {
  count             = length(var.availability_zones)
  allocation_id     =  aws_eip.private_vpc_nat_ip.*.id[count.index] 
  subnet_id         =  aws_subnet.public_subnets.*.id[count.index] 

  tags={
    Name="${var.env}-pblc-sbnt-rt-${var.availability_zones[count.index]}"
  } 
}