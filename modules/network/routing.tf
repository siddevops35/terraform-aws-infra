resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.default.id
  route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.default.id
  }
  tags = {
    Name = "${var.vpc_name}-Public-RT"
    environment = var.environment
  }
}

resource "aws_route_table" "private-route-table" {
  count = length(var.azs)
  vpc_id = aws_vpc.default.id
  route {
     cidr_block = "0.0.0.0/0"
     //gateway_id = aws_internet_gateway.default.id
      nat_gateway_id = element(var.nat_gateway,count.index)
  }
  tags = {
    Name = "${var.vpc_name}-Private-RT"
    environment = var.environment
  }
}

resource "aws_route_table_association" "public-subnet" {
  count = length(var.public_cidr_block)
  subnet_id = element(aws_subnet.public-subnet.*.id, count.index)
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "private-subnet" {
  count = length(var.private_cidr_block)
  subnet_id = element(aws_subnet.private-subnet.*.id, count.index)
  route_table_id = aws_route_table.private-route-table[count.index].id
}