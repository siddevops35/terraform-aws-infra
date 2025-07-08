resource "aws_instance" "public-server" {
  count = length(var.public_subnets_id)
  ami = var.amis
  instance_type = "t2.micro"
  key_name = var.key_name
  subnet_id = element(var.public_subnets_id, count.index)
  vpc_security_group_ids = [var.sg_id]
  associate_public_ip_address = true
   
   tags ={
    Name = "${var.vpc_name}-Public-server-${count.index}"
    environment = "var.environment"
   }

}