# Frontend Dockerfile for production
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
# Check https://github.com/nodejs/docker-node/tree/b4117f9333da4138b03a546ec926ef50a31506c3#nodealpine to understand why libc6-compat might be needed.
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy package files
COPY package*.json ./
COPY packages/intervo-frontend/package*.json ./packages/intervo-frontend/
COPY packages/intervo-widget/package*.json ./packages/intervo-widget/

# Install dependencies
RUN npm ci --legacy-peer-deps

# Rebuild the source code only when needed
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

# Build widget first
RUN npm run build --workspace=intervo-widget

# Build frontend
RUN npm run build --workspace=intervo-frontend

# Production image, copy all the files and run next
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production
# Uncomment the following line in case you want to disable telemetry during runtime.
# ENV NEXT_TELEMETRY_DISABLED 1

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

# Copy the standalone build
COPY --from=builder /app/packages/intervo-frontend/.next/standalone ./
COPY --from=builder /app/packages/intervo-frontend/.next/static ./packages/intervo-frontend/.next/static
COPY --from=builder /app/packages/intervo-frontend/public ./packages/intervo-frontend/public

# Copy widget build
COPY --from=builder /app/packages/intervo-widget/dist ./packages/intervo-widget/dist

USER nextjs

EXPOSE 3000

ENV PORT 3000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "packages/intervo-frontend/server.js"]
