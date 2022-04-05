variable "availability_zones" {
  description = "AWS Region Availability Zones"
}

variable "asg_min_size" {
  description = "Min instance count for ASG"
}

variable "asg_max_size" {
  description = "Max instance count for ASG"
}

variable "alb_tg_arn" {
  description = "tg_arn"
  }

variable "ami" {
 }

 variable "vpc_id" {
   description = "VPC ID for LB"
 }

variable "instance_type" {
 }

 variable "subnets" {
   type = list(string)
}

variable "sshkey" {
  }

variable "alb_sg" {
  }

variable "cidr_block" {
      }
