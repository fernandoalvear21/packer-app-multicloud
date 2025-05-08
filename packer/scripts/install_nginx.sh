#!/bin/bash
set -e

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt-get update

# Instalar Nginx
echo "Instalando Nginx..."
sudo apt-get install -y nginx

# Configurar firewall
echo "Configurando firewall..."
sudo ufw allow 'Nginx Full'

# Habilitar e iniciar Nginx
echo "Iniciando Nginx..."
sudo systemctl enable nginx
sudo systemctl start nginx