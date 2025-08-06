# 🔥 HEXAGONOS - Odoo 18 Docker Implementation

Una implementación completa y profesional de Odoo 18 con Docker Compose, diseñada para el proyecto Hexagonos.

## 🚀 Características

- **Odoo 18**: Última versión estable
- **PostgreSQL 15**: Base de datos optimizada
- **PgAdmin 4**: Interfaz de administración de base de datos
- **Docker Compose**: Orquestación de contenedores
- **Variables de entorno**: Configuración flexible y segura
- **Scripts de automatización**: Setup y gestión simplificada
- **Makefile**: Comandos rápidos para operaciones comunes
- **Naming consistente**: Todo usa el prefijo "hexagonos"

## 📁 Estructura del Proyecto

```
hexagonos-odoo/
├── docker-compose.yml          # Configuración principal de servicios
├── .env                        # Variables de entorno
├── config/
│   ├── odoo.conf              # Configuración de Odoo
│   └── servers.json           # Configuración de servidores PgAdmin
├── addons/                    # Addons personalizados de Odoo
├── logs/                      # Logs de la aplicación
├── backups/                   # Backups de la base de datos
├── setup.sh                   # Script de configuración inicial
├── Makefile                   # Comandos de gestión
└── README.md                  # Esta documentación
```

## 🔧 Instalación Rápida

### 1. Clonar y preparar

```bash
git clone <tu-repositorio> hexagonos-odoo
cd hexagonos-odoo
```

### 2. Configurar variables de entorno

```bash
cp .env.example .env
# Editar .env con tus configuraciones específicas
```

### 3. Ejecutar setup automático

```bash
make setup
```

O manualmente:

```bash
chmod +x setup.sh
./setup.sh
```

## 🎯 Acceso a Servicios

| Servicio | URL | Credenciales |
|----------|-----|--------------|
| **Odoo** | http://localhost:8069 | Master: `H3x4g0n0s_M4st3r_2024!` |
| **PgAdmin** | http://localhost:5050 | Email: `admin@hexagonos.com`<br>Pass: `H3x4g0n0s_PgAdm1n_2024!` |
| **PostgreSQL** | localhost:5432 | User: `hexagonos_user`<br>Pass: `H3x4g0n0s_2024!` |

## 🛠️ Comandos Principales

### Con Makefile (Recomendado)

```bash
# Ver todos los comandos disponibles
make help

# Configuración inicial
make setup

# Gestión de servicios
make up          # Iniciar servicios
make down        # Detener servicios
make restart     # Reiniciar servicios
make status      # Ver estado

# Logs y monitoreo
make logs        # Ver logs de todos los servicios
make logs-odoo   # Ver logs solo de Odoo
make monitor     # Monitorear recursos

# Base de datos
make backup      # Crear backup
make restore FILE=backup.sql  # Restaurar backup
make shell-db    # Acceder al shell de PostgreSQL

# Desarrollo
make shell-odoo  # Acceder al shell de Odoo
make install-addon ADDON=nombre_addon  # Instalar addon
```

### Con Docker Compose

```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down

# Reiniciar un servicio específico
docker-compose restart hexagonos-odoo
```

## 🔒 Configuración de Seguridad

### Passwords por Defecto

⚠️ **IMPORTANTE**: Cambiar todas las contraseñas en producción:

- Master Password: `H3x4g0n0s_M4st3r_2024!`
- Admin Password: `H3x4g0n0s_4dm1n_2024!`
- PostgreSQL Password: `H3x4g0n0s_2024!`
- PgAdmin Password: `H3x4g0n0s_PgAdm1n_2024!`

### Variables de Entorno Importantes

```bash
# Seguridad
ODOO_MASTER_PASSWORD=tu_password_seguro
POSTGRES_PASSWORD=tu_password_db_seguro
PGADMIN_PASSWORD=tu_password_pgadmin_seguro

# Configuración
ENVIRONMENT=production
DEBUG=False
```

## 📊 Configuración de Producción

### Workers y Performance

En `config/odoo.conf`:

```ini
workers = 4                    # Número de workers
max_cron_threads = 2          # Threads para cron jobs
db_maxconn = 64               # Conexiones máximas a DB
limit_memory_hard = 2684354560 # Límite de memoria hard
limit_memory_soft = 2147483648 # Límite de memoria soft
```

### Proxy Reverso (Nginx)

```nginx
server {
    listen 80;
    server_name tu-dominio.com;
    
    location / {
        proxy_pass http://localhost:8069;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    location /longpolling {
        proxy_pass http://localhost:8072;
    }
}
```

## 💾 Gestión de Backups

### Backup Automático

```bash
# Crear backup manual
make backup

# Programar backup automático (crontab)
0 2 * * * cd /path/to/hexagonos-odoo && make backup
```

### Restaurar Backup

```bash
# Restaurar desde archivo específico
make restore FILE=hexagonos_backup_20241205_020000.sql
```

## 🔧 Desarrollo y Addons

### Estructura de Addons

```
addons/
├── mi_addon_personalizado/
│   ├── __init__.py
│   ├── __manifest__.py
│   ├── models/
│   ├── views/
│   └── static/
```

### Instalar Addon Personalizado

```bash
# Copiar addon a la carpeta addons/
cp -r mi_addon addons/

# Reiniciar Odoo
make restart-odoo

# Instalar addon
make install-addon ADDON=mi_addon
```

## 🐛 Troubleshooting

### Problemas Comunes

1. **Odoo no inicia**
   ```bash
   make logs-odoo
   # Verificar configuración en config/odoo.conf
   ```

2. **Error de conexión a DB**
   ```bash
   make logs-db
   # Verificar variables en .env
   ```

3. **Permisos de archivos**
   ```bash
   sudo chown -R 101:101 addons/ logs/
   chmod -R 755 addons/ logs/
   ```

4. **Limpiar instalación**
   ```bash
   make clean
   make setup-clean
   ```

### Logs Útiles

```bash
# Ver logs en tiempo real
make logs

# Ver logs específicos de Odoo
docker-compose exec hexagonos-odoo tail -f /var/log/odoo/odoo.log

# Ver logs de PostgreSQL
make logs-db
```

## 📈 Monitoreo

### Recursos del Sistema

```bash
# Monitorear recursos
make monitor

# Información del sistema
make info

# Estado de servicios
make status
```

### Métricas Importantes

- CPU y memoria de contenedores
- Conexiones a la base de datos
- Tamaño de logs
- Espacio en volúmenes

## 🔄 Actualizaciones

### Actualizar Odoo

```bash
# Detener servicios
make down

# Actualizar imagen
docker-compose pull hexagonos-odoo

# Iniciar con nueva imagen
make up
```

### Actualizar Addons

```bash
make update-addons
```

## 🤝 Contribución

1. Fork el proyecto
2. Crear rama feature (`git checkout -b feature/AmazingFeature`)
3. Commit cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir Pull Request

## 📝 Licencia

Este proyecto está bajo la licencia MIT. Ver `LICENSE` para más detalles.

## 📞 Soporte

Para soporte técnico:
- Crear issue en GitHub
- Revisar documentación de Odoo: https://www.odoo.com/documentation
- Consultar logs: `make logs`

---

## 🎉 ¡Hexagonos está listo!

Tu implementación de Odoo 18 está configurada y lista para usar. ¡Que tengas un excelente desarrollo! 🚀