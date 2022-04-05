output "vpc_public_subnets" {
  description = "Public subnets IDs"
  value = aws_subnet.public_subnet.*.id
}

output "vpc_private_subnets" {
  description = "Private subnets IDs"
  value = aws_subnet.private_subnet.*.id
}

output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.myvpc.id
}
