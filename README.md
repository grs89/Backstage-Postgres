# Backstage Docker Compose

Este directorio contiene la configuración para ejecutar Backstage usando Docker Compose.

## 📋 Requisitos

- Docker Engine 20.10+
- Docker Compose 2.0+

## 🚀 Inicio Rápido

1. **Iniciar los servicios:**

```bash
docker-compose up -d
```

2. **Verificar el estado:**

```bash
docker-compose ps
```

3. **Acceder a Backstage:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:7007

## 📁 Estructura de Archivos

- `docker-compose.yml` - Definición de servicios (Backstage + PostgreSQL)
- `app-config.yaml` - Configuración principal de Backstage
- `app-config.local.yaml` - Configuraciones locales y sensibles (no versionado)
- `.env.example` - Plantilla de variables de entorno

## ⚙️ Configuración

### Variables de Entorno

Copia el archivo de ejemplo y personalízalo:

```bash
cp .env.example .env
```

Edita `.env` con tus valores:
- Credenciales de la base de datos
- Tokens de integración (GitHub, GitLab, etc.)

### Integraciones

Para habilitar integraciones (GitHub, GitLab, etc.):

1. Edita `app-config.local.yaml` con tus tokens
2. Descomenta las secciones relevantes en `app-config.yaml`

**Ejemplo para GitHub:**

```yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
```

## 🗄️ Base de Datos

PostgreSQL está configurado con:
- Usuario: `backstage`
- Contraseña: `backstage_password` (cambiar en producción)
- Base de datos: `backstage`
- Puerto: `5432`

Los datos se persisten en el volumen `postgres-data`.

## 📝 Comandos Útiles

### Ver logs

```bash
# Todos los servicios
docker-compose logs -f

# Solo Backstage
docker-compose logs -f backstage

# Solo PostgreSQL
docker-compose logs -f postgres
```

### Reiniciar servicios

```bash
docker-compose restart
```

### Detener servicios

```bash
docker-compose down
```

### Detener y eliminar volúmenes

```bash
docker-compose down -v
```

## 🔧 Personalización

### Modificar puertos

Edita el archivo `docker-compose.yml` en la sección `ports`:

```yaml
ports:
  - "3000:3000"  # Frontend
  - "7007:7007"  # Backend
```

### Usar una imagen específica de Backstage

Si tienes tu propia imagen de Backstage:

```yaml
backstage:
  image: tu-registry/backstage:tag
  # o para construir localmente:
  # build: ./path/to/backstage
```

## 🔐 Seguridad

> **IMPORTANTE**: Este setup es para desarrollo local. Para producción:

- [ ] Cambia todas las contraseñas predeterminadas
- [ ] Usa secretos de Docker o gestores de secretos
- [ ] Configura HTTPS/TLS
- [ ] Implementa autenticación apropiada
- [ ] Revisa las políticas de CORS y CSP

## 📚 Recursos

- [Documentación oficial de Backstage](https://backstage.io/docs)
- [Backstage GitHub](https://github.com/backstage/backstage)
- [Guía de configuración](https://backstage.io/docs/conf/)

## 🐛 Troubleshooting

### Backstage no puede conectar a la base de datos

1. Verifica que PostgreSQL esté saludable:
   ```bash
   docker-compose ps
   ```

2. Revisa los logs:
   ```bash
   docker-compose logs postgres
   ```

### Puerto ya en uso

Si los puertos 3000 o 7007 están ocupados, modifica el `docker-compose.yml`:

```yaml
ports:
  - "8080:3000"  # Usar puerto 8080 en lugar de 3000
```

### Reinstalar desde cero

```bash
docker-compose down -v
docker-compose up -d
```
