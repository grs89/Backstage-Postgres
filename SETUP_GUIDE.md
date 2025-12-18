# Guía para Setup de Backstage con Docker

Backstage **no tiene una imagen oficial pre-compilada** en Docker Hub. Cada organización debe construir su propia aplicación. Aquí hay **3 opciones**:

---

## 🎯 Opción 1: Usar Demo de Roadie (Más Rápido)

Roadie mantiene una imagen demo de Backstage que puedes usar para pruebas:

```bash
# Edita docker-compose.yml y usa:
image: roadie/backstage-demo:latest
```

---

## 🏗️ Opción 2: Crear tu Propia App de Backstage (Recomendado)

### Paso 1: Crear la aplicación Backstage

```bash
# En el directorio actual
npx @backstage/create-app@latest
```

Esto creará una carpeta con el nombre de tu app (ej: `my-backstage-app`).

### Paso 2: Mover archivos

```bash
# Mover el contenido a este directorio
mv my-backstage-app/* .
mv my-backstage-app/.* . 2>/dev/null || true
rmdir my-backstage-app
```

### Paso 3: Actualizar configuración

El `create-app` genera su propio `app-config.yaml`. Combínalo con el que ya tienes aquí o reemplázalo.

### Paso 4: Usar el Dockerfile multi-stage

Usa el `Dockerfile` que ya está en este directorio (el que tiene multi-stage build).

### Paso 5: Construir y ejecutar

```bash
docker-compose up -d --build
```

---

## 🐳 Opción 3: Usar Imagen de la Comunidad

Algunas imágenes no oficiales disponibles:

```yaml
# En docker-compose.yml
image: backstage/backstage-demo:latest  # Demo básico
# O
image: roadie/backstage:latest  # De Roadie
```

**Nota**: Estas no son oficiales y pueden no estar actualizadas.

---

## 📋 Mi Recomendación

**Para desarrollo/pruebas rápidas**: Usa la Opción 1 (Roadie demo)

**Para uso real**: Usa la Opción 2 (tu propia app)

### Comandos rápidos para Opción 2:

```bash
# 1. Crear app
npx @backstage/create-app@latest --skip-install

# 2. Responder las preguntas del wizard
# Nombre: my-backstage-app (o el que prefieras)

# 3. Entrar al directorio creado
cd my-backstage-app

# 4. Instalar dependencias
yarn install

# 5. Volver y preparar para Docker
cd ..
mv my-backstage-app/* .
mv my-backstage-app/.* . 2>/dev/null || true
rmdir my-backstage-app

# 6. Construir y ejecutar con Docker
docker-compose up -d --build
```

---

## ⚡ Solución Temporal (Sin Docker Build)

Si solo quieres probar Backstage rápidamente sin Docker:

```bash
# Crear app
npx @backstage/create-app@latest

# Entrar al directorio
cd my-backstage-app

# Configurar PostgreSQL (editar app-config.yaml)
# Cambiar de sqlite a postgresql

# Instalar dependencias
yarn install

# Ejecutar en desarrollo
yarn dev
```

Esto iniciará Backstage en `http://localhost:3000` sin necesidad de Docker.

---

¿Cuál opción prefieres que implementemos?
