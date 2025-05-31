resource "aws_instance" "main" {
  for_each                  = var.subnet_id_map 
  instance_type             = var.instance_type
  ami                       = var.ami_id
  subnet_id                 = each.value
  vpc_security_group_ids    = [ var.security_group_id ]
  iam_instance_profile      = var.iam_instance_profile


  instance_market_options {
    market_type = "spot"
    spot_options {

        instance_interruption_behavior  = "stop"
        spot_instance_type              = "persistent" 
      
    }
  }
  root_block_device {
    volume_size                         = var.volume_size
  }
  # user data script

  user_data = base64encode(templatefile("${path.module}/script.sh",{

        AWS_USER     = var.aws_user
        AWS_PASSWORD = var.aws_password
        role_name    = var.name
  }))


  tags={
    Name="${var.env}-${var.name}-${each.key}-instance"
  }

}