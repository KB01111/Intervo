# Dokploy Open Source Deployment Setup - Summary

## 📁 Files Created

The following files have been created for your Dokploy deployment based on the [Intervo Open Source Documentation](https://docs.intervo.ai/open-source/setup):

### Core Deployment Files
- **`dokploy-docker-compose.yml`** - Docker Compose file optimized for Dokploy (follows open source structure)
- **`.env.production.example`** - Production environment variables template (based on open source docs)
- **`DOKPLOY_DEPLOYMENT.md`** - Comprehensive deployment guide

### Environment Configuration Files
- **`Intervo/packages/intervo-backend/.env.production`** - Backend environment variables
- **`Intervo/packages/intervo-frontend/.env.production`** - Frontend environment variables
- **`Intervo/packages/intervo-widget/.env.production`** - Widget environment variables

### Health Check Endpoints
- **`Intervo/packages/intervo-frontend/src/app/api/health/route.js`** - Frontend health endpoint
- **Backend health endpoint** - Already exists at `/health`
- **RAG API health endpoint** - Added to `packages/intervo-backend/rag_py/api.py`

### Deployment Tools
- **`deploy-to-dokploy.sh`** - Automated deployment preparation script

## 🚀 Quick Start

1. **Run the deployment script:**
   ```bash
   ./deploy-to-dokploy.sh
   ```

2. **Configure your environment:**
   - Edit `.env.production` with your actual values
   - Replace `yourdomain.com` with your domain
   - Add API keys and secrets

3. **Set up DNS records:**
   ```
   A    app.yourdomain.com    → YOUR_SERVER_IP
   A    api.yourdomain.com    → YOUR_SERVER_IP  
   A    rag.yourdomain.com    → YOUR_SERVER_IP
   ```

4. **Deploy to Dokploy:**
   - Upload `dokploy-docker-compose.yml`
   - Set environment variables
   - Deploy

## 🔧 Key Features

### Automatic Domain Setup
- **Frontend**: `app.yourdomain.com` - Next.js application
- **Backend API**: `api.yourdomain.com` - Node.js Express server
- **RAG API**: `rag.yourdomain.com` - Python FastAPI server
- **Database**: Internal MongoDB (no external access)

### SSL/HTTPS Configuration
- Automatic SSL certificates via Let's Encrypt
- HTTP to HTTPS redirects
- Secure communication between services

### Open Source Optimizations
- Uses Node.js 20 Alpine and Python 3.11 Slim images (matching open source setup)
- Volume mounts for development-style deployment with persistence
- Health checks for zero-downtime deployments
- Production environment configurations following open source structure
- Automatic widget build integration

### Dokploy Integration
- Uses `dokploy-network` for internal communication
- Traefik labels for automatic routing
- Proper volume structure with `../files/` mounts
- Health checks for service monitoring

## 🏗️ Architecture (Open Source Structure)

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend      │    │   Backend API   │    │   RAG API       │
│ (Node.js Alpine) │    │ (Node.js Alpine) │    │ (Python Slim)   │
│ Next.js:3000    │    │ Express:3003    │    │ FastAPI:4003    │
│ app.domain.com  │    │ api.domain.com  │    │ rag.domain.com  │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │    MongoDB 7    │
                    │   (Jammy)       │
                    │    Port 27017   │
                    │ admin/password123│
                    └─────────────────┘
```

## 🔍 Health Check Endpoints

- **Frontend**: `GET https://app.yourdomain.com/api/health`
- **Backend**: `GET https://api.yourdomain.com/health`
- **RAG API**: `GET https://rag.yourdomain.com/health`

## 📋 Environment Variables

Key variables to configure in `.env.production` (based on open source docs):

```env
# Core Settings
NODE_ENV=production
MONGO_URI=mongodb://admin:password123@mongodb:27017/intervo?authSource=admin

# Security (REQUIRED - minimum 32 characters)
SESSION_SECRET=your-super-secret-session-key-minimum-32-characters
NEXTAUTH_SECRET=your-jwt-secret-key-minimum-32-characters
ENCRYPTION_KEY=your-encryption-key-exactly-32-chars

# Twilio (REQUIRED for phone functionality)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your-twilio-auth-token
TWILIO_API_KEY=SKxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_API_SECRET=your-twilio-api-secret
TWILIO_APP_SID=APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+1234567890

# AI Services (REQUIRED)
OPENAI_API_KEY=sk-your-openai-api-key
GROQ_API_KEY=gsk_your-groq-api-key

# Speech Services (REQUIRED)
ASSEMBLYAI_API_KEY=your-assemblyai-api-key
AZURE_SPEECH_KEY=your-azure-speech-key
ELEVENLABS_API_KEY=your-elevenlabs-api-key

# AWS Services (REQUIRED)
AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

# Google Services (REQUIRED)
GOOGLE_CLIENT_ID=your-google-client-id.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

## 🚨 Important Notes

1. **Replace Domain Placeholders**: Change all instances of `yourdomain.com` to your actual domain
2. **Secure Secrets**: Generate strong, unique secrets for JWT and session keys
3. **DNS Propagation**: Allow 5-10 minutes for DNS changes to propagate
4. **SSL Certificates**: Let's Encrypt certificates are issued automatically
5. **Data Persistence**: All data is stored in Dokploy's `../files/` structure

## 📞 Support

For deployment issues:
1. Check the comprehensive guide in `DOKPLOY_DEPLOYMENT.md`
2. Run the deployment script with `./deploy-to-dokploy.sh`
3. Verify DNS and SSL configuration
4. Check Dokploy logs for any errors

## ✅ Deployment Checklist

- [ ] Run `./deploy-to-dokploy.sh`
- [ ] Configure `.env.production` with actual values
- [ ] Set up DNS A records
- [ ] Upload Docker Compose file to Dokploy
- [ ] Set environment variables in Dokploy
- [ ] Deploy the application
- [ ] Verify all health endpoints
- [ ] Test SSL certificates
- [ ] Confirm application functionality

---

**Ready to deploy!** 🚀 Follow the steps above and your Intervo application will be running on Dokploy with automatic domain setup and SSL certificates.
