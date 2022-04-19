variable "domain" {
  description = "domain for all service infrastructure"
}

variable "mypage-tags" {
    description = "TAGS for AWS Resources"
    type = map(string)
  }

variable "lbzone_id" {
  }

variable "lbdns_name" {
}
