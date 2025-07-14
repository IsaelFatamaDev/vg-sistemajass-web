#!/bin/bash

# Script para construir y ejecutar la aplicación en modo desarrollo con Docker

set -e

echo "🚀 Iniciando contenedor de desarrollo..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_message() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Variables
IMAGE_NAME="sistema-jass-dev"
TAG="latest"
CONTAINER_NAME="sistema-jass-dev-container"
PORT=4200

# Verificar si Docker está instalado
if ! command -v docker &> /dev/null; then
    print_error "Docker no está instalado."
    exit 1
fi

print_message "Deteniendo contenedor anterior si existe..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

print_message "Construyendo imagen de desarrollo..."
docker build -t $IMAGE_NAME:$TAG .

if [ $? -eq 0 ]; then
    print_success "Imagen construida exitosamente: $IMAGE_NAME:$TAG"
else
    print_error "Error al construir la imagen"
    exit 1
fi

print_message "Ejecutando contenedor en modo desarrollo..."
docker run -d \
    --name $CONTAINER_NAME \
    -p $PORT:$PORT \
    -e PORT=$PORT \
    -e NODE_ENV=development \
    -e NG_CLI_ANALYTICS=false \
    --restart unless-stopped \
    $IMAGE_NAME:$TAG

if [ $? -eq 0 ]; then
    print_success "Contenedor ejecutándose en modo desarrollo"
    print_message "La aplicación estará disponible en: http://localhost:$PORT"
    print_message "Esperando a que Angular se inicie..."

    # Esperar a que la aplicación esté lista
    print_message "Verificando que la aplicación esté funcionando..."
    sleep 10

    print_message "Para ver los logs en tiempo real: docker logs -f $CONTAINER_NAME"
    print_message "Para detener el contenedor: docker stop $CONTAINER_NAME"

    # Mostrar logs iniciales
    echo ""
    print_message "Logs iniciales:"
    docker logs $CONTAINER_NAME

else
    print_error "Error al ejecutar el contenedor"
    exit 1
fi

print_success "🎉 Contenedor de desarrollo listo!"
