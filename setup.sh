#!/bin/bash

# =============================================================================
# HEXAGONOS - Script de Configuración e Instalación
# =============================================================================

set -e

echo "🔥 Iniciando configuración de Hexagonos Odoo 18..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_message() {
    echo -e "${BLUE}[HEXAGONOS]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado. Por favor instala Docker primero."
    exit 1
fi

# Verificar si Docker Compose está instalado
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    print_error "Docker Compose no está instalado. Por favor instala Docker Compose primero."
    exit 1
fi

# Crear directorios necesarios
print_message "Creando estructura de directorios..."
mkdir -p config
mkdir -p addons
mkdir -p logs
mkdir -p backups

# Verificar que existe el archivo .env
if [ ! -f .env ]; then
    print_error "El archivo .env no existe. Por favor créalo usando el ejemplo proporcionado."
    exit 1
fi

# Cargar variables del .env
source .env

print_success "Variables de entorno cargadas correctamente"

# Crear archivo de configuración de Odoo si no existe
if [ ! -f config/odoo.conf ]; then
    print_warning "config/odoo.conf no encontrado. Por favor créalo usando la plantilla proporcionada."
fi

# Crear archivo de configuración de servidores para PgAdmin si no existe
if [ ! -f config/servers.json ]; then
    print_warning "config/servers.json no encontrado. Por favor créalo usando la plantilla proporcionada."
fi

# Configurar permisos
print_message "Configurando permisos de directorios..."
sudo chown -R 101:101 addons/
sudo chown -R 101:101 logs/
chmod -R 755 addons/
chmod -R 755 logs/

# Detener contenedores existentes si están corriendo
print_message "Deteniendo contenedores existentes..."
docker-compose down --remove-orphans 2>/dev/null || true

# Limpiar volúmenes si se solicita
if [ "$1" == "--clean" ]; then
    print_warning "Limpiando volúmenes existentes..."
    docker volume rm hexagonos-db-data hexagonos-odoo-web-data hexagonos-pgadmin-data 2>/dev/null || true
fi

# Construir e iniciar servicios
print_message "Iniciando servicios de Hexagonos..."
docker-compose up -d

# Esperar a que los servicios estén listos
print_message "Esperando a que los servicios estén listos..."
sleep 10

# Verificar estado de los servicios
print_message "Verificando estado de los servicios..."

# Verificar PostgreSQL
if docker-compose exec -T hexagonos-db pg_isready -U $POSTGRES_USER -d $POSTGRES_DB; then
    print_success "PostgreSQL está funcionando correctamente"
else
    print_error "PostgreSQL no está funcionando"
    exit 1
fi

# Verificar Odoo
if curl -s http://localhost:$ODOO_PORT/web/health > /dev/null; then
    print_success "Odoo está funcionando correctamente"
else
    print_warning "Odoo puede estar iniciando aún. Verificar en unos minutos."
fi

# Mostrar información de acceso
echo ""
echo "=========================================="
echo "🎉 HEXAGONOS CONFIGURADO EXITOSAMENTE 🎉"
echo "=========================================="
echo ""
echo "📊 Servicios disponibles:"
echo "• Odoo:    http://localhost:$ODOO_PORT"
echo "• PgAdmin: http://localhost:$PGADMIN_PORT"
echo ""
echo "🔐 Credenciales:"
echo "• Odoo Master Password: $ODOO_MASTER_PASSWORD"
echo "• PgAdmin Email: $PGADMIN_EMAIL"
echo "• PgAdmin Password: $PGADMIN_PASSWORD"
echo "• PostgreSQL User: $POSTGRES_USER"
echo "• PostgreSQL Password: $POSTGRES_PASSWORD"
echo ""
echo "📁 Directorios importantes:"
echo "• Addons: ./addons/"
echo "• Logs: ./logs/"
echo "• Config: ./config/"
echo "• Backups: ./backups/"
echo ""
echo "🚀 Para gestionar los servicios:"
echo "• Iniciar: docker-compose up -d"
echo "• Detener: docker-compose down"
echo "• Ver logs: docker-compose logs -f"
echo "• Reiniciar: docker-compose restart"
echo ""
print_success "¡Configuración completada! Hexagonos está listo para usar."