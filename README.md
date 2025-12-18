# Backstage Docker Setup

## Estado Actual

La aplicación Backstage se ha configurado correctamente con Docker Compose y un Dockerfile multi-stage. Todos los archivos de la aplicación (`packages/`, `app-config.yaml`, etc.) se han generado localmente.

### ✅ Lo que funciona:
1. **Docker Compose**: Levanta PostgreSQL y el contenedor de la app.
2. **Build de Docker**: La imagen se construye correctamente.
3. **Inicio de la App**: Backstage arranca y es accesible en `http://localhost:3000`.

### ⚠️ Limitaciones Conocidas (Scaffolder Deshabilitado):
El plugin **Scaffolder** está deshabilitado en el código (`packages/backend/src/index.ts`) debido a problemas de compilación con la dependencia nativa `isolated-vm` en el entorno Docker.

Si necesitas la funcionalidad de plantillas (Scaffolder), deberás ejecutar la aplicación localmente fuera de Docker (ver sección de Desarrollo Local abajo) o resolver la compilación de `isolated-vm` en el Dockerfile.

## 🚀 Solución Recomendada: Desarrollo Local

La forma más estable de ejecutar Backstage en macOS (dado los problemas de compilación cruzada en Docker) es ejecutar la app en tu máquina host y la base de datos en Docker.

### Pasos:

1. **Asegúrate de que PostgreSQL esté corriendo:**
   ```bash
   docker compose up -d postgres
   ```


2. **Instala dependencias localmente:**
   Esto compilará `isolated-vm` correctamente para tu Mac.
   ```bash
   cd backstage-app
   yarn install
   ```

3. **Inicia Backstage:**
   ```bash
   yarn dev
   ```
   
   Accede a http://localhost:3000

## 🔧 Intentar Docker de nuevo

Si deseas intentar arreglar la compilación en Docker en el futuro:
1. Necesitas investigar por qué `node-gyp` falla al compilar `isolated-vm` en `node:20-bookworm-slim`.
2. Podrías intentar usar una imagen base más completa como `node:20-bullseye` (no slim) que tenga más herramientas de desarrollo, aunque `build-essential` y `python3` ya se están instalando.

## Archivos Importantes
- `docker-compose.yml`: Orquestación de servicios (en raíz).
- `backstage-app/Dockerfile`: Definición de la imagen.
- `backstage-app/app-config.production.yaml`: Configuración para producción.
- `backstage-app/`: Directorio con el código fuente de la aplicación.
