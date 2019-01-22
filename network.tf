resource "aws_subnet" "public_subnet1" {
  cidr_block = "${var.subnet1_address}"
  vpc_id = "${aws_vpc.MyVPC.id}"
  map_public_ip_on_launch = true
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
  tags {
    Name = "public_subnet1"
  }
}

### Route ###
resource "aws_route_table" "rtb_public" {
  vpc_id = "${aws_vpc.MyVPC.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
    tags {
    Name = "rtb_public"
  }
}

resource "aws_route_table_association" "rta-public_subnet1" {
  route_table_id = "${aws_route_table.rtb_public.id}"
  subnet_id = "${aws_subnet.public_subnet1.id}"
}
