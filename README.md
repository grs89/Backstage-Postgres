# Backstage Docker Setup

Este proyecto contiene una instancia básica de Backstage configurada para ejecutarse con Docker Compose.

## Estado del Proyecto

### ✅ Características Habilitadas
1. **Docker Compose**: Orquestación completa de servicios (App + Postgres).
2. **Base de Datos**: PostgreSQL 15 integrado.
3. **Scaffolder (Plantillas)**: Habilitado en el código del backend (`packages/backend`).
4. **Desarrollo Local**: Configuración optimizada para evitar errores de permisos 401 (`permission.enabled: false`).

### ⚠️ Notas Importantes
- **Compilación de `isolated-vm`**: El plugin Scaffolder depende de `isolated-vm`. En algunos entornos (especialmente Mac con chips M1/M2/M3), la compilación de este módulo nativo dentro de Docker puede fallar o causar inestabilidad.
- **Permisos**: El framework de permisos está temporalmente deshabilitado (`permission.enabled: false`) en `app-config.yaml` para facilitar el desarrollo local sin políticas complejas.

---

## 🚀 Inicio Rápido (Docker)

Esta es la forma estándar de ejecutar todo el entorno.

1. **Construir e Iniciar Contenedores:**
   ```bash
   docker compose up -d --build
   ```
   *Nota: El flag `--build` es crucial si has modificado código (como habilitar plugins).*

2. **Acceder a Backstage:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:7007

3. **Ver logs:**
   ```bash
   docker compose logs -f backstage
   ```

4. **Detener:**
   ```bash
   docker compose down
   ```

---

## 🛠 Desarrollo Híbrido (Recomendado para Mac/M1)

Si encuentras problemas con la compilación de módulos nativos dentro de Docker, se recomienda ejecutar la base de datos en Docker y la aplicación Backstage localmente en tu host.

1. **Iniciar solo la Base de Datos:**
   ```bash
   docker compose up -d postgres
   ```

2. **Instalar dependencias y ejecutar Backstage localmente:**
   ```bash
   cd backstage-app
   yarn install
   yarn dev
   ```
   *Esto utilizará tu compilador local (Xcode Command Line Tools) para `isolated-vm`, lo cual es mucho más robusto en macOS.*

---

## 🔧 Solución de Problemas Comunes

### Error 401 Unauthorized / Failed to load entity kinds
- **Causa**: El framework de permisos está habilitado pero no configurado para el usuario Guest.
- **Solución**: Asegúrate de que `permission.enabled: false` esté establecido en `app-config.yaml`. (Ya aplicado en este proyecto).

### Error en `isolated-vm` o `python` durante `docker build`
- **Causa**: Fallo en la compilación de dependencias nativas en la imagen Docker `slim`.
- **Solución**: Usa el métod "Desarrollo Híbrido" descrito arriba para compilar nativamente en tu máquina.

### Backstage no conecta a Postgres
- **Causa**: Configuración de host incorrecta.
- **Solución**:
    - En Docker: `POSTGRES_HOST: postgres` (nombre del servicio).
    - Localmente: `POSTGRES_HOST: localhost` (asegúrate de que `127.0.0.1` esté habilitado en `app-config.local.yaml` si existe).

---

## Estructura de Archivos
- `docker-compose.yml`: Define los servicios `backstage-app` y `postgres`.
- `backstage-app/`: Directorio raíz del monorepo Backstage.
  - `packages/backend/src/index.ts`: Punto de entrada del backend (donde se registran plugins como Scaffolder).
  - `app-config.yaml`: Configuración principal.
  - `Dockerfile`: Definición de la imagen del contenedor.
