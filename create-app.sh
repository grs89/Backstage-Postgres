#!/bin/bash

echo "🎭 Creando aplicación Backstage en el directorio actual..."

# Verificar que Node.js está instalado
if ! command -v node &> /dev/null; then
    echo "❌ Node.js no está instalado. Por favor instala Node.js 18+ primero."
    exit 1
fi

echo "📦 Creando aplicación con npx @backstage/create-app..."
npx @backstage/create-app@latest

# Encontrar el directorio creado
APP_DIR=$(ls -td */ 2>/dev/null | grep -v postgres-data | grep -v node_modules | head -1 | sed 's#/##')

if [ -n "$APP_DIR" ]; then
    echo "✅ Aplicación creada en $APP_DIR"
    echo "📂 Moviendo archivos al directorio actual..."
    
    # Mover todo el contenido
    mv "$APP_DIR"/* . 2>/dev/null
    mv "$APP_DIR"/.* . 2>/dev/null || true
    rmdir "$APP_DIR"
    
    echo ""
    echo "✅ ¡Configuración completada!"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Ejecuta: docker compose up -d --build"
    echo "2. Espera unos minutos mientras se construye la imagen"
    echo "3. Accede a http://localhost:3000"
    echo ""
else
    echo "❌ No se pudo crear la aplicación"
    exit 1
fi
