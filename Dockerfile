FROM node:20-bullseye-slim

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    python3 \
    g++ \
    build-essential \
    git \
    curl \
    sqlite3 \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /build

# Create Backstage app with a specific name
ENV BACKSTAGE_APP_NAME=my-backstage-app

RUN npx @backstage/create-app@latest --skip-install <<EOF
${BACKSTAGE_APP_NAME}


EOF

# Move to the created app directory
WORKDIR /build/${BACKSTAGE_APP_NAME}

# Update app-config.yaml for PostgreSQL
RUN sed -i 's/client: better-sqlite3/client: pg/g' app-config.yaml && \
    sed -i '/connection: :memory:/d' app-config.yaml

# Add PostgreSQL configuration to database section
RUN sed -i '/database:/a\    client: pg' app-config.yaml && \
    sed -i '/client: pg/a\    connection:' app-config.yaml && \
    sed -i '/connection:/a\      host: ${POSTGRES_HOST}' app-config.yaml && \
    sed -i '/host:/a\      port: ${POSTGRES_PORT}' app-config.yaml && \
    sed -i '/port:/a\      user: ${POSTGRES_USER}' app-config.yaml && \
    sed -i '/user:/a\      password: ${POSTGRES_PASSWORD}' app-config.yaml && \
    sed -i '/password:/a\      database: backstage' app-config.yaml

# Install dependencies first
RUN yarn install --frozen-lockfile

# Add pg dependency to backend package using yarn workspace
RUN yarn workspace backend add pg

# Build backend
RUN yarn tsc && \
    yarn build:backend

# Production stage
FROM node:20-bullseye-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the application
COPY --from=0 /build/my-backstage-app /app

# Expose ports
EXPOSE 3000 7007

# Set environment
ENV NODE_ENV=production

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=90s \
    CMD curl -f http://localhost:7007/healthcheck || exit 1

# Start application
CMD ["node", "packages/backend", "--config", "app-config.yaml"]
