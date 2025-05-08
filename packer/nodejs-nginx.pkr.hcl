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
  scripts_path = "${path.root}/scripts"
  files_path = "${path.root}/files"
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

  # Ejecutar scripts de instalación
  provisioner "shell" {
    scripts = [
      "${local.scripts_path}/install_nodejs.sh",
      "${local.scripts_path}/install_nginx.sh",
      "${local.scripts_path}/configure_app.sh"
    ]
    execute_command = "chmod +x {{ .Path }}; sudo sh -c '{{ .Vars }} {{ .Path }}'"
  }

  # Copiar y configurar Nginx
  provisioner "file" {
    source = "${local.files_path}/nginx.conf"
    destination = "/tmp/nginx.conf"
  }

  provisioner "shell" {
    inline = [
      "sudo mv /tmp/nginx.conf /etc/nginx/sites-available/default",
      "sudo systemctl restart nginx"
    ]
  }
}