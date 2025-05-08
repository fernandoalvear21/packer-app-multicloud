packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
    azure = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/azure"
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

# Definición de la fuente Azure
source "azure-arm" "ubuntu" {
  use_azure_cli_auth = true
  
  managed_image_name = "nodejs-nginx-${local.timestamp}"
  managed_image_resource_group_name = "rg-packer-image"

  os_type = "Linux"
  ssh_username = "azureuser"
  
  image_publisher = "Canonical"
  image_offer = "0001-com-ubuntu-server-focal"
  image_sku = "20_04-lts"
  image_version = "latest"

  location = "eastus"
  vm_size = "Standard_B1s"

  azure_tags = {
    Name        = "nodejs-nginx"
    Environment = "production"
    Builder     = "packer"
  }
}

# Definición del build
build {
  name = "nodejs-nginx"
  sources = [
    "source.amazon-ebs.ubuntu",
    "source.azure-arm.ubuntu"
  ]

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