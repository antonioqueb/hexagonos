# =============================================================================
# HEXAGONOS - Makefile para gestión de servicios
# =============================================================================

.PHONY: help setup up down restart logs clean backup restore shell-odoo shell-db status

# Colores para output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m

# Variables
COMPOSE_FILE := docker-compose.yml
ENV_FILE := .env

help: ## Mostrar ayuda
	@echo "$(GREEN)HEXAGONOS - Comandos disponibles:$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

setup: ## Configuración inicial completa
	@echo "$(GREEN)🔥 Configurando Hexagonos...$(NC)"
	@chmod +x setup.sh
	@if [[ "$OSTYPE" == "darwin"* ]]; then \
		echo "$(YELLOW)Detectado macOS - usando configuración sin sudo$(NC)"; \
	fi
	@./setup.sh

setup-clean: ## Configuración inicial limpia (elimina datos existentes)
	@echo "$(YELLOW)⚠️  Configuración limpia (eliminará datos existentes)...$(NC)"
	@chmod +x setup.sh
	@./setup.sh --clean

setup-macos-clean: ## Configuración inicial limpia para macOS
	@echo "$(YELLOW)🍎 Configuración limpia para macOS (eliminará datos existentes)...$(NC)"
	@chmod +x setup-macos.sh
	@./setup-macos.sh --clean

up: ## Iniciar todos los servicios
	@echo "$(GREEN)🚀 Iniciando servicios de Hexagonos...$(NC)"
	@docker-compose up -d

down: ## Detener todos los servicios
	@echo "$(RED)🛑 Deteniendo servicios de Hexagonos...$(NC)"
	@docker-compose down

restart: ## Reiniciar todos los servicios
	@echo "$(YELLOW)♻️  Reiniciando servicios de Hexagonos...$(NC)"
	@docker-compose restart

restart-odoo: ## Reiniciar solo Odoo
	@echo "$(YELLOW)♻️  Reiniciando Odoo...$(NC)"
	@docker-compose restart hexagonos-odoo

logs: ## Ver logs de todos los servicios
	@docker-compose logs -f

logs-odoo: ## Ver logs de Odoo
	@docker-compose logs -f hexagonos-odoo

logs-db: ## Ver logs de PostgreSQL
	@docker-compose logs -f hexagonos-db

logs-pgadmin: ## Ver logs de PgAdmin
	@docker-compose logs -f hexagonos-pgadmin

status: ## Ver estado de los servicios
	@echo "$(GREEN)📊 Estado de servicios de Hexagonos:$(NC)"
	@docker-compose ps

clean: ## Limpiar contenedores y volúmenes
	@echo "$(RED)🧹 Limpiando contenedores y volúmenes...$(NC)"
	@docker-compose down --volumes --remove-orphans
	@docker volume prune -f

shell-odoo: ## Acceder al shell de Odoo
	@echo "$(GREEN)🐚 Accediendo al shell de Odoo...$(NC)"
	@docker-compose exec hexagonos-odoo /bin/bash

shell-db: ## Acceder al shell de PostgreSQL
	@echo "$(GREEN)🐚 Accediendo al shell de PostgreSQL...$(NC)"
	@docker-compose exec hexagonos-db psql -U hexagonos_user -d hexagonos_odoo

shell-pgadmin: ## Acceder al shell de PgAdmin
	@echo "$(GREEN)🐚 Accediendo al shell de PgAdmin...$(NC)"
	@docker-compose exec hexagonos-pgadmin /bin/bash

backup: ## Crear backup de la base de datos
	@echo "$(GREEN)💾 Creando backup de la base de datos...$(NC)"
	@mkdir -p backups
	@docker-compose exec -T hexagonos-db pg_dump -U hexagonos_user hexagonos_odoo > backups/hexagonos_backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Backup creado en: backups/hexagonos_backup_$$(date +%Y%m%d_%H%M%S).sql$(NC)"

restore: ## Restaurar backup de la base de datos (usar: make restore FILE=backup.sql)
	@if [ -z "$(FILE)" ]; then \
		echo "$(RED)❌ Error: Especifica el archivo de backup con FILE=nombre_archivo.sql$(NC)"; \
		exit 1; \
	fi
	@echo "$(YELLOW)🔄 Restaurando backup: $(FILE)...$(NC)"
	@docker-compose exec -T hexagonos-db psql -U hexagonos_user -d hexagonos_odoo < backups/$(FILE)
	@echo "$(GREEN)✅ Backup restaurado exitosamente$(NC)"

update-addons: ## Actualizar lista de addons en Odoo
	@echo "$(GREEN)🔄 Actualizando lista de addons...$(NC)"
	@docker-compose exec hexagonos-odoo odoo -d hexagonos_odoo -u all --stop-after-init

install-addon: ## Instalar addon específico (usar: make install-addon ADDON=nombre_addon)
	@if [ -z "$(ADDON)" ]; then \
		echo "$(RED)❌ Error: Especifica el addon con ADDON=nombre_addon$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)📦 Instalando addon: $(ADDON)...$(NC)"
	@docker-compose exec hexagonos-odoo odoo -d hexagonos_odoo -i $(ADDON) --stop-after-init

create-db: ## Crear nueva base de datos (usar: make create-db DB=nombre_db)
	@if [ -z "$(DB)" ]; then \
		echo "$(RED)❌ Error: Especifica el nombre de la DB con DB=nombre_db$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN)🗃️  Creando base de datos: $(DB)...$(NC)"
	@docker-compose exec hexagonos-db createdb -U hexagonos_user $(DB)

monitor: ## Monitorear recursos de los contenedores
	@echo "$(GREEN)📈 Monitoreando recursos de Hexagonos...$(NC)"
	@docker stats hexagonos-odoo hexagonos-postgres hexagonos-pgadmin

info: ## Mostrar información del sistema
	@echo "$(GREEN)ℹ️  Información del sistema Hexagonos:$(NC)"
	@echo ""
	@echo "🐳 Docker version:"
	@docker --version
	@echo ""
	@echo "🐙 Docker Compose version:"
	@docker-compose --version
	@echo ""
	@echo "📊 Estado de servicios:"
	@docker-compose ps
	@echo ""
	@echo "💾 Volúmenes:"
	@docker volume ls | grep hexagonos
	@echo ""
	@echo "🌐 Red:"
	@docker network ls | grep hexagonos

open-odoo: ## Abrir Odoo en el navegador (macOS)
	@if [[ "$OSTYPE" == "darwin"* ]]; then \
		echo "$(GREEN)🍎 Abriendo Odoo en el navegador...$(NC)"; \
		open http://localhost:8069; \
	else \
		echo "$(YELLOW)Este comando es específico para macOS$(NC)"; \
	fi

open-pgadmin: ## Abrir PgAdmin en el navegador (macOS)
	@if [[ "$OSTYPE" == "darwin"* ]]; then \
		echo "$(GREEN)🍎 Abriendo PgAdmin en el navegador...$(NC)"; \
		open http://localhost:5050; \
	else \
		echo "$(YELLOW)Este comando es específico para macOS$(NC)"; \
	fi