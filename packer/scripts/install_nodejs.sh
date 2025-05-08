#!/bin/bash
set -e

# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt-get update
sudo apt-get upgrade -y

# Instalar Node.js
echo "Instalando Node.js..."
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# Verificar instalación
node --version
npm --version

# Instalar PM2 globalmente
echo "Instalando PM2..."
sudo npm install -g pm2

# Crear directorio de la aplicación
sudo mkdir -p /var/www/nodejs

# Asignar permisos directamente al usuario ubuntu
sudo chown -R ubuntu:ubuntu /var/www/nodejs