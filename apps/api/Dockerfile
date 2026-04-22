# =============================================================================
# NATS Console API - Simple and reliable Dockerfile for Dokploy
# =============================================================================

FROM node:20-alpine

WORKDIR /app

RUN apk add --no-cache libc6-compat
RUN corepack enable && corepack prepare pnpm@9.14.2 --activate

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY apps/api/package.json ./apps/api/
COPY apps/shared/package.json ./apps/shared/

RUN pnpm install --frozen-lockfile

COPY apps/shared ./apps/shared
COPY apps/api ./apps/api

RUN pnpm --filter @nats-console/api prisma generate
RUN pnpm --filter @nats-console/shared build
RUN pnpm --filter @nats-console/api build

ENV NODE_ENV=production
ENV PORT=3001
ENV HOST=0.0.0.0

WORKDIR /app/apps/api

EXPOSE 3001

CMD ["node", "dist/index.js"]
