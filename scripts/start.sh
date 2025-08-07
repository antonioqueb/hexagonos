#!/bin/bash

# Script para iniciar Odoo 18 con Docker Compose
echo "Iniciando Odoo 18 con Docker Compose..."

# Crear directorios necesarios
mkdir -p config addons logs backups

# Verificar si existe el archivo de configuración
if [ ! -f "config/odoo.conf" ]; then
    echo "Error: No se encuentra el archivo config/odoo.conf"
    echo "Por favor, asegúrate de tener el archivo de configuración en su lugar."
    exit 1
fi

# Detener contenedores existentes
echo "Deteniendo contenedores existentes..."
docker-compose down

# Construir e iniciar los servicios
echo "Iniciando servicios..."
docker-compose up -d

# Mostrar estado de los contenedores
echo "Estado de los contenedores:"
docker-compose ps

# Mostrar logs en tiempo real
echo "Mostrando logs de Odoo..."
echo "Presiona Ctrl+C para salir de los logs (los contenedores seguirán ejecutándose)"
sleep 2
docker-compose logs -f web