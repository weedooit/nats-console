# =============================================================================
#tcg"
# =============================================================================
# N NATS Console API - Reliable Dockerfile for Dokploy
# =============================================================================

FROM node:20ATS Console API - Reliable Dockerfile for Dokploy
# =============================================================================

FROM node:20-alpine AS builder

WORKDIR /app

RUN-alpine AS builder

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@9.14 corepack enable && corepack prepare pnpm@9.14.2 --activate.2 --activate

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY apps/api/package.json ./apps/api/
COPY

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml turbo.json ./
COPY apps/api/package.json ./apps/api/
COPY apps/shared/package.json ./apps/shared/

RUN apps/shared/package.json ./apps/shared/

RUN pnpm install --f pnpm install --frozen-lockfile

COPY apps/shared ./apps/shared
COPYrozen-lockfile

COPY apps/shared ./apps/shared
COPY apps/api ./apps/api

RUN apps/api ./apps/api

RUN pnpm --filter @nats-console/api prisma generate
RUN pnpm --filter @nats-console/shared build
RUN pnpm --filter @nats-console/api prisma generate
RUN pnpm --filter @nats-console/shared build
RUN pnpm --filter @nats-console/api build

FROM node:20 pnpm --filter @nats-console/api build

FROM node:20-alpine AS runner

WORKDIR /app

RUN apk add --no-cache libc6-compat

COPY --from=builder /app-alpine AS runner

WORKDIR /app

RUN apk add --no-cache libc6-compat

COPY --from=builder /app/node_modules ./node_modules

COPY --from=builder /app/apps/shared/dist ./apps/shared/dist
COPY --from=builder/node_modules ./node_modules

COPY --from=builder /app/apps/shared/dist ./apps/shared/dist
COPY --from=builder /app /app/apps/shared/package.json ./apps/shared/

COPY/apps/shared/package.json ./apps/shared/

COPY --from=builder /app --from=builder /app/apps/api/dist ./apps/api/dist
COPY --from=builder /app/apps/api/package.json ./apps/api/
COPY --from=builder /app/apps/api/dist ./apps/api/dist
COPY --from=builder /app/apps/api/package.json ./apps/api/
COPY --from=builder /app/apps/api/prisma ./apps/api/prisma

COPY package.json pnpm-workspace.yaml ./

ENV NODE_ENV=production/apps/api/prisma ./apps/api/prisma

COPY package.json pnpm-workspace.yaml ./

ENV NODE_ENV=production
ENV PORT=3001
ENV HOST=0.0.0
ENV PORT=3001
ENV HOST=0.0.0.0

WORK.0

WORKDIR /appDIR /app/apps/api

EX/apps/api

EXPOSE 3001

CMD ["node", "distPOSE 3001

CMD ["node", "dist/index.js"]
