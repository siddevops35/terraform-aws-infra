resource "aws_security_group" "allow-all" {
  name = "${var.vpc_name}_allow_all"
  vpc_id = var.vpc_id
  
   dynamic "ingress" {
     for_each = var.ingress_port_value
     content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
     }
   }

    egress  {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
    tags ={
        Name = "${var.vpc_name}-allow-all"
        environment = var.environment
    }
}
