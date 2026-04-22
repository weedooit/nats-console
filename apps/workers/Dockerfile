# =============================================================================
# NATS Console Workers - Simple and reliable Dockerfile for Dokploy
# =============================================================================

FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache libc6-compat
RUN corepack enable && corepack prepare pnpm@9.14.2 --activate

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY apps/workers/package.json ./apps/workers/
COPY apps/shared/package.json ./apps/shared/
COPY apps/api/prisma ./apps/api/prisma

RUN pnpm install --frozen-lockfile

COPY apps/shared ./apps/shared
COPY apps/workers ./apps/workers
COPY apps/api/prisma ./apps/api/prisma

RUN ./node_modules/.bin/prisma generate --schema=apps/api/prisma/schema.prisma

RUN pnpm --filter @nats-console/shared build
RUN pnpm --filter @nats-console/workers build

ENV NODE_ENV=production

WORKDIR /app/apps/workers

CMD ["sh", "-lc", "/app/node_modules/.bin/prisma generate --schema=/app/apps/api/prisma/schema.prisma && node dist/index.js"]
