# Etapa 1: Construcción de dependencias Python
FROM python:3.11-slim-bullseye AS builder

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --prefix=/install --no-cache-dir -r requirements.txt

# Etapa 2: Imagen final
FROM python:3.11-slim-bullseye

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends libpq-dev && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /install /usr/local

# Copiar scripts y darles permisos de ejecución
COPY entrypoint.sh /app/entrypoint.sh
COPY wait-for-it.sh /app/wait-for-it.sh
RUN chmod +x /app/entrypoint.sh /app/wait-for-it.sh

# Copiar el código fuente
COPY . /app

# Crear usuario no root y cambiar permisos
RUN useradd -m familia_user && \
    chown -R familia_user /app

USER familia_user

EXPOSE 8000

ENTRYPOINT ["/app/entrypoint.sh"]
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers", "3", "--timeout", "120", "sitio_familia.wsgi:application"]