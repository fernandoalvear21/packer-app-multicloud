# Proyecto de Despliegue con Packer - Node.js y Nginx

## Descripción
Este proyecto implementa un despliegue automatizado de una aplicación Node.js con Nginx utilizando Packer, con soporte para múltiples proveedores de nube (AWS y Azure). La solución permite crear imágenes de máquinas virtuales idénticas en ambas plataformas, garantizando consistencia en el despliegue.

## Requisitos
- Packer >= 1.0.0
- AWS CLI configurado
- Azure CLI configurado
- Cuenta de AWS con permisos adecuados
- Cuenta de Azure con permisos adecuados
- Node.js y npm
- PM2 (instalado globalmente)
- Nginx

## Estructura del Proyecto
```plaintext
.
├── packer/
│   ├── nodejs-nginx.pkr.hcl    # Template de Packer
│   ├── files/
│   │   └── nginx.conf          # Configuración de Nginx
│   └── scripts/
│       ├── install_nodejs.sh   # Instalación de Node.js
│       ├── install_nginx.sh    # Instalación de Nginx
│       └── configure_app.sh    # Configuración de la aplicación

# Configuración y despliegue 
## Preparación de Entorno
1. AWS
   - Configura tu cuenta de AWS con las credenciales necesarias.
   ```bash
   aws configure
   ```
2. Azure
   - Configura tu cuenta de Azure con las credenciales necesarias.
   ```bash
   az login
   ```
## Construcción de Imágenes
1. Inicializa Packer.
   ```bash
   packer init packer/nodejs-nginx.pkr.hcl
   ```
2. Construir la imagen para ambos proveedores.
   ```bash
   packer build packer/nodejs-nginx.pkr.hcl
   ```
## Despliegue en AWS y Azure
1. Despliega la imagen en AWS.
   ```bash
   aws ec2 run-instances --image-id ami-xxxxxxxx --instance-type t2.micro
   ```
2. Despliega la imagen en Azure.
   ```bash
   az vm create --resource-group myResourceGroup --name myVM --image myImage --admin-username azureuser --generate-ssh-keys
   ```
## Resultados y Verificación
- Verifica que la aplicación Node.js se ejecute correctamente en ambas instancias.
- Accede a la aplicación a través de Nginx en ambos entornos.
## Limpieza
- Elimina las instancias y recursos creados en AWS y Azure.
```bash
aws ec2 terminate-instances --instance-ids instance-id
az vm delete --resource-group myResourceGroup --name myVM
``` 
## Consideraciones Adicionales
- Ajusta los parámetros de configuración según tus necesidades específicas.
- Asegúrate de que las credenciales de AWS y Azure estén actualizadas y válidas.
- Utiliza el script de configuración de la aplicación para ajustar la aplicación según tus requisitos.
