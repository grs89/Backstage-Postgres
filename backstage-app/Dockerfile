# Stage 1 - Build phase
FROM node:20-bookworm-slim AS build

# Instalar dependencias del sistema necesarias para la compilación
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python-is-python3 \
    g++ \
    make \
    pkg-config \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable

USER node
WORKDIR /app

# Copiar todo el código fuente primero para asegurar workspaces correctos
COPY --chown=node:node . .

# Instalar dependencias
RUN yarn install --network-timeout 600000

# Compilar el backend y el frontend
RUN yarn tsc
RUN yarn build:backend

# Stage 2 - Production phase
FROM node:20-bookworm-slim

# Instalar dependencias de ejecución (aisladas de la compilación)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

RUN corepack enable

USER node
WORKDIR /app

# Copiar node_modules y build desde Stage 1
COPY --from=build --chown=node:node /app/node_modules ./node_modules
COPY --from=build --chown=node:node /app/packages/backend/dist/bundle.tar.gz ./bundle.tar.gz
RUN tar xzf bundle.tar.gz && rm bundle.tar.gz
COPY --chown=node:node app-config.yaml app-config.production.yaml ./

CMD ["node", "packages/backend", "--config", "app-config.yaml", "--config", "app-config.production.yaml"]