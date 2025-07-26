# Backend Dockerfile for production
FROM node:20-alpine AS base

# Install dependencies only when needed
FROM base AS deps
RUN apk add --no-cache libc6-compat
WORKDIR /app

# Copy package files
COPY packages/intervo-backend/package*.json ./

# Install dependencies
RUN npm ci --only=production

# Production image
FROM base AS runner
WORKDIR /app

ENV NODE_ENV production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 backend

# Copy node_modules and source code
COPY --from=deps /app/node_modules ./node_modules
COPY packages/intervo-backend/ ./

# Change ownership to backend user
RUN chown -R backend:nodejs /app
USER backend

EXPOSE 3003

CMD ["node", "server.js"]
