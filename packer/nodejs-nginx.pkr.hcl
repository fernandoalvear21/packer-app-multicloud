packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

# Variables locales
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

# Definición de la fuente Amazon EBS
source "amazon-ebs" "ubuntu" {
  ami_name      = "nodejs-nginx-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"] # Canonical Ubuntu
  }

  ssh_username = "ubuntu"

  tags = {
    Name        = "nodejs-nginx"
    Environment = "production"
    Builder     = "packer"
  }
}

# Definición del build
build {
  name = "nodejs-nginx"
  sources = ["source.amazon-ebs.ubuntu"]
}