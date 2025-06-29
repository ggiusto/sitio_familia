#!/bin/bash
echo "Esperando a la base de datos..."
/app/wait-for-it.sh db:5432 --timeout=30 --strict -- echo "Base de datos disponible."

echo "Ejecutando migraciones..."
python manage.py migrate --noinput

echo "Recopilando archivos estáticos..."
python manage.py collectstatic --noinput

echo "Iniciando servidor Gunicorn..."
exec "$@"
