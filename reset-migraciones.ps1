# 1. Eliminar migraciones excepto __init__.py
Write-Host "🧹 Eliminando archivos de migración..."
Get-ChildItem -Recurse -Include *.py -Path .\ -Filter migrations |
    Where-Object { $_.Name -ne "__init__.py" } |
    Remove-Item -Force -ErrorAction SilentlyContinue

# 2. Eliminar archivos .pyc
Write-Host "🧹 Eliminando archivos .pyc..."
Get-ChildItem -Recurse -Include *.pyc -Path .\ |
    Remove-Item -Force -ErrorAction SilentlyContinue

# 3. Eliminar volumen de PostgreSQL (ajustá el nombre si es necesario)
$volName = "sitio_familia_postgres_data"
Write-Host "🗑 Eliminando volumen Docker: $volName"
docker volume rm $volName 2>$null

# 4. Reconstruir y levantar contenedores
Write-Host "🐳 Levantando contenedores con Docker Compose..."
docker-compose down
docker-compose up --build -d

# Esperar un poco a que la DB esté lista (puede ajustarse si es necesario)
Start-Sleep -Seconds 10

# 5. Ejecutar makemigrations y migrate
Write-Host "🛠 Ejecutando makemigrations y migrate..."
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate

Write-Host "`n✅ Migraciones reseteadas y aplicadas con éxito." -ForegroundColor Green
