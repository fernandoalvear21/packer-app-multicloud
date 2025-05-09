#!/bin/bash
set -e

# Configurar la aplicación Node.js
echo "Configurando la aplicación Node.js..."
cd /var/www/nodejs

# Inicializar proyecto Node.js
npm init -y

# Instalar Express
npm install express

# Crear archivo de aplicación
cat << EOF > app.js
const express = require('express');
const app = express();
const port = 3000;

app.get('/', (req, res) => {
  res.send('¡Aplicación Node.js funcionando correctamente!');
});

app.listen(port, '0.0.0.0', () => {
  console.log(\`Aplicación ejecutándose en puerto \${port}\`);
});
EOF

# Configurar PM2 para inicio automático
echo "Configurando PM2..."
pm2 start app.js
pm2 save
env PATH=$PATH:/usr/bin pm2 startup systemd -u ubuntu --hp /home/ubuntu
sudo systemctl enable pm2-ubuntu