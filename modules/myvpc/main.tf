resource "aws_vpc" "myvpc"{
  cidr_block  = "10.0.0.0/16"

  tags = merge(tomap(
  {Name = "mypage_vpc"}),
    var.mypage-tags
)
}

data "aws_availability_zones" "available"{
  state = "available"
}

resource "aws_subnet" "public_subnet" {
  count = "${var.azcount}"
  vpc_id  = aws_vpc.myvpc.id
  cidr_block  = "10.0.${count.index}.0/24"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"


  tags = merge(tomap({
    Name = "public_subnet_${element(data.aws_availability_zones.available.names, count.index)}"}),
    var.mypage-tags
)
}

resource "aws_subnet" "private_subnet" {
  count = "${var.azcount}"
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.10${count.index}.0/24"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"

  tags = merge(tomap({
    Name = "private_subnet_${element(data.aws_availability_zones.available.names, count.index)}"}),
    var.mypage-tags
)
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = merge(tomap(
  {Name = "mypage_igw"}),
    var.mypage-tags
)
}

resource "aws_route_table" "r_t_public" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = merge(tomap(
  {Name = "mypage_route_table"}),
    var.mypage-tags,
)
}

resource "aws_route_table_association" "public_subnet_rt_as" {
  count = "${length(aws_subnet.public_subnet.*.id)}"
  subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
  route_table_id = "${aws_route_table.r_t_public.id}"

}
