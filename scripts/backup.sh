#!/bin/bash

# Script para realizar backup de la base de datos de Odoo
DATABASE_NAME=${1:-""}
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)

if [ -z "$DATABASE_NAME" ]; then
    echo "Uso: $0 <nombre_base_datos>"
    echo "Ejemplo: $0 odoo_production"
    exit 1
fi

# Crear directorio de backups si no existe
mkdir -p $BACKUP_DIR

# Realizar backup
echo "Realizando backup de la base de datos: $DATABASE_NAME"
docker-compose exec db pg_dump -U odoo -d $DATABASE_NAME > "$BACKUP_DIR/${DATABASE_NAME}_${DATE}.sql"

if [ $? -eq 0 ]; then
    echo "Backup completado: $BACKUP_DIR/${DATABASE_NAME}_${DATE}.sql"
    
    # Comprimir el backup
    gzip "$BACKUP_DIR/${DATABASE_NAME}_${DATE}.sql"
    echo "Backup comprimido: $BACKUP_DIR/${DATABASE_NAME}_${DATE}.sql.gz"
else
    echo "Error al realizar el backup"
    exit 1
fi