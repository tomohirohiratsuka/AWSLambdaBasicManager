####################################################
# Route Table
####################################################
resource "aws_route_table" "ig_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}
####################################################
# Route Table Association
####################################################
resource "aws_route_table_association" "public_1a_to_ig" {
  route_table_id = aws_route_table.ig_table.id
  subnet_id      = aws_subnet.public_1a.id
}

resource "aws_route_table_association" "public_1c_to_ig" {
  route_table_id = aws_route_table.ig_table.id
  subnet_id      = aws_subnet.public_1c.id
}