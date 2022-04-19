
variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  description = "VPC ID for LB"
}

variable "certificate_arn" {
}

variable "mypage-tags" {
    description = "TAGS for AWS Resources"
    type = map(string)
  }
