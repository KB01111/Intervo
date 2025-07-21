# Intervo Dokploy Environment Setup Guide

This guide provides step-by-step instructions for configuring your Intervo application for Dokploy deployment with the atlas-agent.net domain.

## 🚀 Quick Setup

### 1. Environment Files Created

The following environment files have been created and configured for your atlas-agent.net domain:

- ✅ `.env.production` - Main backend environment variables
- ✅ `packages/intervo-frontend/.env.local` - Frontend environment variables  
- ✅ `packages/intervo-widget/.env` - Widget environment variables
- ✅ `dokploy-docker-compose.yml` - Updated with correct domain

### 2. Domain Configuration

Your app is configured for these domains:
- **Frontend**: https://app.atlas-agent.net
- **Backend API**: https://api.atlas-agent.net  
- **RAG API**: https://rag.atlas-agent.net

## 🔧 Required Configuration Steps

### Step 1: Update API Keys in .env.production

Edit `.env.production` and replace the placeholder values with your actual API keys:

```bash
# Security Keys (GENERATE STRONG 32+ CHARACTER SECRETS)
SESSION_SECRET=your-super-secret-session-key-minimum-32-characters
NEXTAUTH_SECRET=your-jwt-secret-key-minimum-32-characters
ENCRYPTION_KEY=your-encryption-key-exactly-32-chars

# Twilio (Required for phone functionality)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your-twilio-auth-token
TWILIO_API_KEY=SKxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_API_SECRET=your-twilio-api-secret
TWILIO_APP_SID=APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+1234567890

# AI Services
OPENAI_API_KEY=sk-your-openai-api-key
GROQ_API_KEY=gsk_your-groq-api-key

# Speech Services
ASSEMBLYAI_API_KEY=your-assemblyai-api-key
AZURE_SPEECH_KEY=your-azure-speech-key
ELEVENLABS_API_KEY=your-elevenlabs-api-key

# AWS Services
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# Google Services
GOOGLE_CLIENT_ID=your-google-client-id.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

### Step 2: Generate Secure Secrets

Generate strong secrets for production:

```bash
# Generate SESSION_SECRET (32+ characters)
openssl rand -base64 32

# Generate NEXTAUTH_SECRET (32+ characters)  
openssl rand -base64 32

# Generate ENCRYPTION_KEY (exactly 32 characters)
openssl rand -base64 24
```

### Step 3: Configure Stripe (Optional)

If using payments, update in `.env.production`:

```bash
STRIPE_SECRET_KEY=sk_live_your-stripe-secret-key
STRIPE_WEBHOOK_SECRET=whsec_your-webhook-secret
```

And in `packages/intervo-frontend/.env.local`:

```bash
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=pk_live_your-stripe-publishable-key
```

## 📦 Dokploy Deployment

### Step 1: Create Project in Dokploy

1. Login to your Dokploy dashboard
2. Create new project: "Intervo"
3. Connect your Git repository

### Step 2: Configure Docker Compose

1. In Dokploy project settings:
   - Set **Docker Compose File**: `dokploy-docker-compose.yml`
   - Set **Environment File**: `.env.production`

### Step 3: Domain Setup

Configure these domains in Dokploy:
- `app.atlas-agent.net` → frontend service (port 3000)
- `api.atlas-agent.net` → backend service (port 3003)  
- `rag.atlas-agent.net` → rag-api service (port 4003)

### Step 4: SSL Certificate

Dokploy will automatically handle SSL certificates via Traefik and your Cloudflare setup.

## 🔍 Verification Steps

### 1. Check Service Health

After deployment, verify each service:

```bash
# Frontend
curl -I https://app.atlas-agent.net

# Backend API
curl -I https://api.atlas-agent.net/health

# RAG API  
curl -I https://rag.atlas-agent.net
```

### 2. Check Logs

Monitor logs in Dokploy dashboard:
- Frontend logs for build/startup issues
- Backend logs for API connectivity
- RAG API logs for Python service status
- MongoDB logs for database connectivity

### 3. Test Core Functionality

1. **Frontend**: Visit https://app.atlas-agent.net
2. **API Connection**: Check if frontend can connect to backend
3. **Database**: Verify MongoDB connection in backend logs
4. **AI Services**: Test AI functionality with your API keys

## 🛠️ Troubleshooting

### Common Issues

1. **Environment Variables Not Loading**
   - Verify `.env.production` is in project root
   - Check Dokploy environment file configuration
   - Restart services after environment changes

2. **CORS Errors**
   - Verify `ALLOWED_ORIGINS` includes all your domains
   - Check frontend `NEXT_PUBLIC_API_URL_PRODUCTION` setting

3. **Database Connection Issues**
   - Verify MongoDB service is running
   - Check `MONGO_URI` format in environment

4. **SSL Certificate Issues**
   - Verify domains are properly configured in Dokploy
   - Check Traefik labels in docker-compose.yml

### Debug Commands

```bash
# Check running containers
docker ps

# View service logs
docker logs <container_name>

# Test internal connectivity
docker exec -it <container_name> ping mongodb
docker exec -it <container_name> ping backend
```

## 🔄 Updates & Maintenance

### Automatic Deployment
- Enable auto-deploy in Dokploy for automatic updates on git push
- Configure webhooks for CI/CD integration

### Manual Updates
1. Push changes to your repository
2. In Dokploy dashboard, click "Redeploy"
3. Monitor deployment progress and logs

## 📋 Environment Variables Reference

### Required Variables (Must be configured)
- `SESSION_SECRET`, `NEXTAUTH_SECRET`, `ENCRYPTION_KEY`
- `TWILIO_*` (for phone functionality)
- `OPENAI_API_KEY`, `GROQ_API_KEY`
- `ASSEMBLYAI_API_KEY`, `AZURE_SPEECH_KEY`, `ELEVENLABS_API_KEY`
- `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`

### Optional Variables
- `STRIPE_*` (for payments)
- `DEEPGRAM_API_KEY`, `VOYAGE_API_KEY` (additional speech services)
- `MAILCOACH_TOKEN` (email marketing)
- `HETZNER_STORAGE_*` (cloud storage)

## ✅ Deployment Checklist

- [ ] Updated all API keys in `.env.production`
- [ ] Generated secure secrets (32+ characters)
- [ ] Configured domains in Dokploy
- [ ] Verified SSL certificates are working
- [ ] Tested frontend accessibility
- [ ] Verified backend API health endpoint
- [ ] Confirmed database connectivity
- [ ] Tested core AI functionality
- [ ] Configured monitoring and logging

Your Intervo application is now ready for production deployment on Dokploy with the atlas-agent.net domain! 🎉
