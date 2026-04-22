# =============================================================================
# NATS Console API - Multi-Stage Docker Build
# Compatible with docker-compose.prod.dokploy.yml
# =============================================================================

# =============================================================================
# Stage 1: Builder
# =============================================================================
FROM node:20-alpine AS builder

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY apps/api/package.json ./apps/api/
COPY apps/shared/package.json ./apps/shared/

RUN pnpm install --frozen-lockfile

COPY apps/shared ./apps/shared
COPY apps/api ./apps/api

RUN pnpm --filter @nats-console/api prisma generate
RUN pnpm --filter @nats-console/shared build
RUN pnpm --filter @nats-console/api build

# =============================================================================
# Stage 2: Production dependencies
# =============================================================================
FROM node:20-alpine AS prod-deps

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY apps/api/package.json ./apps/api/
COPY apps/shared/package.json ./apps/shared/

# Important: hoist dependencies for simpler runtime resolution
RUN pnpm install --frozen-lockfile --prod --shamefully-hoist

# =============================================================================
# Stage 3: Runner
# =============================================================================
FROM node:20-alpine AS runner

WORKDIR /app

# Copy production node_modules
COPY --from=prod-deps /app/node_modules ./node_modules

# Copy built shared package
COPY --from=builder /app/apps/shared/dist ./apps/shared/dist
COPY --from=builder /app/apps/shared/package.json ./apps/shared/

# Copy built API
COPY --from=builder /app/apps/api/dist ./apps/api/dist
COPY --from=builder /app/apps/api/package.json ./apps/api/
COPY --from=builder /app/apps/api/prisma ./apps/api/prisma

# Copy Prisma generated client
COPY --from=builder /app/node_modules/.pnpm/@prisma+client*/node_modules/.prisma ./node_modules/.pnpm/@prisma+client*/node_modules/.prisma

# Workspace files
COPY package.json pnpm-workspace.yaml ./

# Make sure app packages can resolve root node_modules
RUN ln -s /app/node_modules /app/apps/api/node_modules && \
    ln -s /app/node_modules /app/apps/shared/node_modules

WORKDIR /app/apps/api

ENV NODE_ENV=production
ENV PORT=3001
ENV HOST=0.0.0.0

EXPOSE 3001

CMD ["node", "dist/index.js"]
