# Proyecto de Despliegue con Packer - Node.js y Nginx

## Descripción
Este proyecto implementa un despliegue automatizado de una aplicación Node.js con Nginx utilizando Packer para AWS.

## Requisitos
- Packer
- AWS CLI configurado
- Cuenta de AWS con permisos adecuados

## Estructura del Proyecto
```plaintext
.
├── README.md
├── packer/
│   ├── nodejs-nginx.pkr.hcl
│   ├── scripts/
│   │   ├── install_nodejs.sh
│   │   ├── install_nginx.sh
│   │   └── configure_app.sh
│   └── files/
│       └── nginx.conf
└── src/
    └── app.js