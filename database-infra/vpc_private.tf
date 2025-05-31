data "aws_vpc" "vpc_id" {
  
  filter {
    name            ="tag:Name"
    values          = [var.vpc_name]
  }
}

resource "aws_route53_zone" "private_db_dns" {
  name = "db.manupanand.online"

  vpc {
    vpc_id = data.aws_vpc.vpc_id.id
  }
}