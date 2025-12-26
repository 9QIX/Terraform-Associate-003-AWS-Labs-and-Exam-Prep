module "autoscaling" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "8.0.1"
 
  # Autoscaling group
  name = "myasg"
 
  vpc_zone_identifier = [aws_subnet.private_subnets["private_subnet_1"].id, 
  aws_subnet.private_subnets["private_subnet_2"].id, 
  aws_subnet.private_subnets["private_subnet_3"].id]
  min_size            = 0
  max_size            = 1
  desired_capacity    = 1
 
  # Launch template
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
 
  tags = {
    Name = "Web EC2 Server 2"
  }
 
}