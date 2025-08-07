#!/bin/bash

# Script para detener Odoo 18 con Docker Compose
echo "Deteniendo Odoo 18..."

# Detener y eliminar contenedores
docker-compose down

echo "Odoo 18 detenido correctamente."

# Mostrar estado
docker-compose ps