# Dockerfile para desarrollo con ng serve
FROM node:18-alpine

# Establecer directorio de trabajo
WORKDIR /app

# Copiar archivos de configuración de dependencias
COPY package*.json ./

# Instalar todas las dependencias (incluyendo devDependencies para ng serve)
RUN npm install

# Instalar Angular CLI globalmente
RUN npm install -g @angular/cli

# Copiar código fuente
COPY . .

# Exponer el puerto que Railway asignará
EXPOSE $PORT

# Comando para iniciar el servidor de desarrollo
CMD ["sh", "-c", "ng serve --configuration=development --host=0.0.0.0 --port=$PORT --disable-host-check"]
