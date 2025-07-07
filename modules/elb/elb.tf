resource "aws_lb" "test" {
  name = var.lb_name
  load_balancer_type = "application"
  internal           = false
  subnets            = var.subnet_ids
  enable_deletion_protection = false
  tags = {
    environment = var.environment
  }
}
resource "aws_lb_target_group" "test" {
  name     = var.target_group_name
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "test" {
  count = 2
  target_group_arn = aws_lb_target_group.test.arn
  target_id = element(var.public_servers,count.index)
  port = 8080
}

resource "aws_lb_listener" "front" {
   load_balancer_arn = aws_lb.test.arn
   port = 80
   protocol = "HTTP"
   default_action {
     type = "forward"
    target_group_arn = aws_lb_target_group.test.arn
   }
}