variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID for LB"
}

variable "cidr_blocks" {
  type = list(string)
}

variable "ami" {
 }

variable "instance_type" {
  }

variable "sshkey" {
  }

variable "mypage-tags" {
    description = "TAGS for AWS Resources"
    type = map(string)
  }
