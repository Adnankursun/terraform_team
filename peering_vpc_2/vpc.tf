resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  tags = {
  Name = "VPC_2"
  }
}
# Private subnets
########################################################################################################################
resource "aws_subnet" "private1" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_private1}"
}
resource "aws_subnet" "private2" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_private2}"
}
resource "aws_subnet" "private3" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_private3}"
}
########################################################################################################################
# Public Subnet
########################################################################################################################
resource "aws_subnet" "public1" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_public1}"
}
resource "aws_subnet" "public2" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_public2}"
}
resource "aws_subnet" "public3" {
    vpc_id     = "${aws_vpc.main.id}"
    cidr_block = "${var.subnet_public3}"
}
########################################################################################################################
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"
}
resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public3.id}"

  tags = {
    Name = "gw NAT"
  }
}

resource "aws_eip" "nat" {
  vpc      = true
}




resource "aws_route_table" "r1" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
}

  resource "aws_route_table" "r2" {
  vpc_id = "${aws_vpc.main.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.natgw.id}"
  }
}
# Route Table association
resource "aws_route_table_association" "b1" {
  subnet_id      = "${aws_subnet.public1.id}"
  route_table_id = "${aws_route_table.r1.id}"
}
resource "aws_route_table_association" "b2" {
  subnet_id      = "${aws_subnet.public2.id}"
  route_table_id = "${aws_route_table.r1.id}"
}
resource "aws_route_table_association" "b3" {
  subnet_id      = "${aws_subnet.public3.id}"
  route_table_id = "${aws_route_table.r1.id}"
}


resource "aws_route_table_association" "a1" {
  subnet_id      = "${aws_subnet.private1.id}"
  route_table_id = "${aws_route_table.r2.id}"
}
resource "aws_route_table_association" "a2" {
  subnet_id      = "${aws_subnet.private2.id}"
  route_table_id = "${aws_route_table.r2.id}"
}
resource "aws_route_table_association" "a3" {
  subnet_id      = "${aws_subnet.private3.id}"
  route_table_id = "${aws_route_table.r2.id}"
}