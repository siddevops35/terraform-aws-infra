resource "aws_eip" "lb" {
  count  = length(var.az)
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.az)
  allocation_id = aws_eip.lb[count.index].id
  subnet_id     = element(var.public_subnet_id, count.index)

  tags = {
    Name = "Nat-gtw-${count.index}"
  }
}