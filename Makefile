# Variables por defecto
DJANGO_APP=web

# Atajos para Docker
up:
	docker-compose up -d

down:
	docker-compose down

restart: down up

logs:
	docker-compose logs -f

# Comandos Django dentro del contenedor
migrate:
	docker-compose exec $(DJANGO_APP) python manage.py migrate

makemigrations:
	docker-compose exec $(DJANGO_APP) python manage.py makemigrations

createsuperuser:
	docker-compose exec $(DJANGO_APP) python manage.py createsuperuser

shell:
	docker-compose exec $(DJANGO_APP) python manage.py shell

collectstatic:
	docker-compose exec $(DJANGO_APP) python manage.py collectstatic --noinput

# Ejecutar pruebas
test:
	docker-compose exec $(DJANGO_APP) python manage.py test

# Limpiar todo (con cuidado)
prune:
	docker-compose down -v --remove-orphans

# Ayuda
help:
	@echo "Comandos disponibles:"
	@echo "  make up               → Levantar contenedores"
	@echo "  make down             → Detener contenedores"
	@echo "  make restart          → Reiniciar contenedores"
	@echo "  make logs             → Ver logs"
	@echo "  make migrate          → Aplicar migraciones"
	@echo "  make makemigrations   → Crear nuevas migraciones"
	@echo "  make createsuperuser  → Crear superusuario"
	@echo "  make shell            → Abrir shell de Django"
	@echo "  make collectstatic    → Recolectar archivos estáticos"
	@echo "  make test             → Ejecutar tests"
	@echo "  make prune            → Borrar volúmenes y huérfanos"
