terraform {
  required_version = "=1.1.2"
  backend "s3" {
    }
 }

provider "aws" {
  region = var.region
 }

module "myvpc" {
  cidr_block = var.cidr_block
  source = "./modules/myvpc"
  region = var.region
  azcount = var.azcount
  mypage-tags =var.mypage-tags
  }


resource "aws_key_pair" "sshpub" {
  key_name = "mywork-ssh"
  public_key = file("${path.root}/modules/sshpub/mywork.pub")
  }

module "r53_cert" {
  source = "./modules/r53_cert"
  domain = var.domain
  }

module "loadb" {
  source = "./modules/loadb"
  subnets = module.myvpc.vpc_public_subnets
  vpc_id = module.myvpc.vpc_id
  certificate_arn = module.r53_cert.kw_cert_arn
  }

  module "asg" {
    source = "./modules/asg"
    vpc_id = module.myvpc.vpc_id
    subnets = module.myvpc.vpc_public_subnets
    asg_max_size = var.asg_max_size
    asg_min_size = var.asg_min_size
    availability_zones = var.availability_zones
    alb_tg_arn = module.loadb.alb_tg_arn
    ami = var.ami
    instance_type = var.instance_type
    sshkey = "mywork-ssh"
    alb_sg = module.loadb.alb_sg
    cidr_block = var.cidr_block
    }

module "bastion" {
  source = "./modules/bastion"
  vpc_id = module.myvpc.vpc_id
  subnets = module.myvpc.vpc_public_subnets
  ami = var.ami
  instance_type = var.instance_type
  cidr_blocks = var.ssh_ip
  sshkey = "mywork-ssh"
  mypage-tags =var.mypage-tags
  }
