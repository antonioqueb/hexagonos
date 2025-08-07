### ./.env

```
# Variables de entorno para Odoo 18
POSTGRES_DB=postgres
POSTGRES_USER=odoo
POSTGRES_PASSWORD=ntp_secure_2025!

# Configuración de Odoo
ODOO_VERSION=18
ODOO_DB_HOST=db
ODOO_DB_PORT=5432
ODOO_DB_USER=odoo
ODOO_DB_PASSWORD=ntp_secure_2025!

# Master Password para Odoo (CAMBIAR ESTE PASSWORD)
ODOO_ADMIN_PASSWD=Hexagonos2025!SecurePassword

# PgAdmin
PGADMIN_DEFAULT_EMAIL=admin@hexagonos.com
PGADMIN_DEFAULT_PASSWORD=pgadmin_secure_2025!

# Puertos
ODOO_PORT=1400
POSTGRES_PORT=5432
PGADMIN_PORT=5050
```

---

### ./config/odoo.conf

```ini
[options]
; Database settings
db_host = db
db_port = 5432
db_user = odoo
db_password = ntp_secure_2025!

; Server settings
http_port = 8069
gevent_port = 8072
workers = 9
max_cron_threads = 2

; Paths
addons_path = /usr/lib/python3/dist-packages/odoo/addons
data_dir = /var/lib/odoo

; Logging
logfile = /var/log/odoo/odoo.log
log_level = info
log_db = True
log_handler = :INFO

; Security
admin_passwd = Hexagonos2025!SecurePassword
db_name = False
list_db = True
db_filter = ^.*$

; Session
session_timeout = 86400

; Performance
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_request = 8192
limit_time_cpu = 600
limit_time_real = 1200

; WebSocket/Longpolling settings
longpolling_port = 8072

; Email settings (opcional)
; smtp_server = localhost
; smtp_port = 587
; smtp_ssl = False
; smtp_user = 
; smtp_password = 

; Language and timezone
; default_language = es_MX
; timezone = America/Mexico_City
```

---

### ./docker-compose.yml

```yaml
services:
  web:
    image: odoo:18
    container_name: odoo18
    depends_on:
      - db
    ports:
      - "1400:8069"  # Tu puerto personalizado 1400
      - "8072:8072"  # Puerto para WebSocket/longpolling
    volumes:
      - odoo-web-data:/var/lib/odoo
      - ./config:/etc/odoo
      - ./addons:/mnt/extra-addons
      - ./logs:/var/log/odoo
    environment:
      - HOST=${ODOO_DB_HOST}
      - USER=${ODOO_DB_USER}
      - PASSWORD=${ODOO_DB_PASSWORD}
      - ODOO_MASTER_PASSWD=${ODOO_ADMIN_PASSWD}
    # Usar solo el archivo de configuración para evitar inconsistencias
    command: odoo --config=/etc/odoo/odoo.conf
    # Configuración optimizada para producción
    deploy:
      resources:
        limits:
          memory: 3G
        reservations:
          memory: 1G
    ulimits:
      nofile:
        soft: 65536
        hard: 65536
    restart: unless-stopped
    networks:
      - odoo-network
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8069/web/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 3

  db:
    image: postgres:15
    container_name: postgres_odoo18
    environment:
      - POSTGRES_DB=${POSTGRES_DB}
      - POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
      - POSTGRES_USER=${POSTGRES_USER}
      - PGDATA=/var/lib/postgresql/data/pgdata
    volumes:
      - odoo-db-data:/var/lib/postgresql/data/pgdata
      - ./backups:/backups
    restart: unless-stopped
    networks:
      - odoo-network
    ports:
      - "5432:5432"
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U odoo"]
      interval: 30s
      timeout: 10s
      retries: 3

  pgadmin:
    image: dpage/pgadmin4:latest
    container_name: pgadmin_odoo18
    environment:
      - PGADMIN_DEFAULT_EMAIL=${PGADMIN_DEFAULT_EMAIL}
      - PGADMIN_DEFAULT_PASSWORD=${PGADMIN_DEFAULT_PASSWORD}
    ports:
      - "5050:80"
    volumes:
      - pgadmin-data:/var/lib/pgadmin
    depends_on:
      - db
    restart: unless-stopped
    networks:
      - odoo-network

  # Nginx para producción - HABILITADO
  nginx:
    image: nginx:alpine
    container_name: nginx_odoo18
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
      - ./nginx/ssl:/etc/nginx/ssl:ro
    depends_on:
      - web
    restart: unless-stopped
    networks:
      - odoo-network

volumes:
  odoo-web-data:
  odoo-db-data:
  pgadmin-data:

networks:
  odoo-network:
    driver: bridge
```

---

### ./nginx/ngnx.conf

```ini
events {
    worker_connections 4096;
    use epoll;
    multi_accept on;
}

http {
    # Optimizaciones de performance
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    keepalive_requests 100;
    
    # Compresión
    gzip on;
    gzip_vary on;
    gzip_min_length 1024;
    gzip_types text/css application/javascript text/javascript application/json application/xml;
    
    # Límites y timeouts
    client_max_body_size 50M;
    client_body_timeout 60s;
    client_header_timeout 60s;
    
    upstream odoo {
        server web:8069 weight=1 fail_timeout=0;
    }

    upstream odoochat {
        server web:8072 weight=1 fail_timeout=0;
    }

    # Rate limiting
    limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;
    limit_conn_zone $binary_remote_addr zone=addr:10m;

    map $http_upgrade $connection_upgrade {
        default upgrade;
        ''      close;
    }

    # Redirect HTTP to HTTPS (descomenta en producción)
    # server {
    #     listen 80;
    #     server_name tu-dominio.com;
    #     return 301 https://$server_name$request_uri;
    # }

    server {
        listen 80;
        server_name localhost;
        
        # Security headers
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header Referrer-Policy "no-referrer-when-downgrade" always;
        
        # Rate limiting
        limit_conn addr 50;
        limit_req zone=login burst=5 nodelay;

        # Proxy settings
        proxy_buffer_size 128k;
        proxy_buffers 8 128k;
        proxy_busy_buffers_size 256k;
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;

        # Headers
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;

        # WebSocket y longpolling
        location /websocket {
            proxy_pass http://odoochat;
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection $connection_upgrade;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Real-IP $remote_addr;
            
            proxy_connect_timeout 7d;
            proxy_send_timeout 7d;
            proxy_read_timeout 7d;
        }

        location /longpolling {
            proxy_pass http://odoochat;
        }

        # Cache para assets estáticos
        location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
            proxy_pass http://odoo;
            proxy_cache_valid 200 60m;
            expires 1M;
            add_header Cache-Control "public, immutable";
        }

        # Ubicaciones sensibles
        location ~ ^/(web/database|web/session) {
            limit_req zone=login burst=3 nodelay;
            proxy_pass http://odoo;
            proxy_redirect off;
        }

        # Todo lo demás
        location / {
            proxy_pass http://odoo;
            proxy_redirect off;
        }

        # Logs
        access_log /var/log/nginx/odoo_access.log;
        error_log /var/log/nginx/odoo_error.log;
    }
}
```

---

### ./scripts/backup.sh

```bash
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
```

---

### ./scripts/start.sh

```bash
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
```

---

### ./scripts/stop.sh

```bash
#!/bin/bash

# Script para detener Odoo 18 con Docker Compose
echo "Deteniendo Odoo 18..."

# Detener y eliminar contenedores
docker-compose down

echo "Odoo 18 detenido correctamente."

# Mostrar estado
docker-compose ps
```

---

