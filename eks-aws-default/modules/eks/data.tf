data "aws_subnet" "kube_subnet_a" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.private_vpc.id]
  }
  filter{
    name ="tag:Name"
    values = [var.subnet_name_2a] 
  }
}
data "aws_subnet" "kube_subnet_b" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.private_vpc.id]
  }
  filter{
    name ="tag:Name"
    values = [var.subnet_name_2b]
  }
}
data "aws_subnet" "kube_subnet_c" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.private_vpc.id]
  }
  filter{
    name ="tag:Name"
    values = [var.subnet_name_2c]
  }
}

data "aws_vpc" "private_vpc" {
    
  filter {
    name = "tag:Name"
    values = [var.vpc_name]
  }
}

