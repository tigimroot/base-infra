variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "ami" {
  description = "ami for mypage"
  default = "ami-0a8b4cd432b1c3063"
}

variable "instance_type" {
  description = "instance_type for mypage"
  default = "t2.micro"
}

variable "azcount" {
  description = "Count of Availability Zones"
  default = "2"
}

variable "asg_min_size" {
  description = "Min instance count for ASG"
  default = "2"
}

variable "asg_max_size" {
  description = "Max instance count for ASG"
  default = "3"
}

variable "key" {
  }

variable "bucket" {
}

variable "octarine-domain" {
  default = "a1.nubes.academy"
}

variable "ssh_ip" {
  description = "admin ip adresses"
  default = ["46.138.222.51/32"]
}