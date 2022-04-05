resource "aws_vpc" "myvpc"{
  cidr_block  = "10.0.0.0/16"
  tags  = {
    "Env":"Prod"
    "Name":"OC-7-octarine-vpc"
    "Region":"${var.region}"
  }
}

data "aws_availability_zones" "available"{
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  count = "${var.azcount}"
  vpc_id  = aws_vpc.myvpc.id
  cidr_block  = "10.0.${count.index}.0/24"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = {
    "Name":"public_subnet_${element(data.aws_availability_zones.available.names, count.index)}"
    "Env":"Prod"
  }
}

resource "aws_subnet" "private_subnet" {
  count = "${var.azcount}"
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.10${count.index}.0/24"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = {
    "Name":"private_subnet_${element(data.aws_availability_zones.available.names, count.index)}"
    "Env":"Prod"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    "Env":"Prod"
  }
}

resource "aws_route_table" "r_t_public" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    "Name":"OC-7_route_table_${aws_vpc.myvpc.id}"
    "Env":"Prod"
  }
}

resource "aws_route_table_association" "public_subnet_rt_as" {
  count = "${length(aws_subnet.public_subnet.*.id)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.r_t_public.id}"

}
