variable "region" {}

variable "azcount" {
  description = "Count of Availability Zones"
}

variable "cidr_block" {
  }

variable "mypage-tags" {
    description = "TAGS for AWS Resources"
    type = map(string)
  }
