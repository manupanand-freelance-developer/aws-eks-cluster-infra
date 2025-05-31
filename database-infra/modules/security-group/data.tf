data "aws_vpc" "vpc_id" {
  
  filter {
    name            ="tag:Name"
    values          = [var.vpc_name]
  }
}
data "aws_subnet" "subnet_id"{
    for_each = var.subnet_name
    filter {
      name          ="vpc-id"
      values        = [data.aws_vpc.vpc_id.id]
    }       
    filter {
      name = "tag:Name"
      values = [each.value]
    }
}
