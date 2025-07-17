# Dokploy Quick Setup Guide - Atlas Agent

## 🌐 Using atlas-agent.net Wildcard Domain

Your deployment is configured to use the `atlas-agent.net` wildcard domain with Cloudflare certificates:

- **Frontend**: `https://app.atlas-agent.net`
- **Backend API**: `https://api.atlas-agent.net`
- **RAG API**: `https://rag.atlas-agent.net`

## 🚨 Fix for Current Deployment Error

The deployment failed due to missing environment variables. Here's how to fix it:

## 1. Configure Environment Variables in Dokploy UI

In your Dokploy dashboard, go to your project settings and add these environment variables:

### Required Variables (Replace with your actual values):

```
# Core Security
SESSION_SECRET=your-super-secret-session-key-minimum-32-characters
NEXTAUTH_SECRET=your-jwt-secret-key-minimum-32-characters
ENCRYPTION_KEY=your-encryption-key-exactly-32-chars

# Supabase Authentication (REQUIRED)
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.your-actual-anon-key
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.your-actual-service-role-key
SUPABASE_JWT_SECRET=your-supabase-jwt-secret-from-settings

# NextAuth Configuration
NEXTAUTH_URL=https://api.atlas-agent.net

# Application URLs
BASE_URL=https://api.atlas-agent.net
FRONTEND_URL=https://app.atlas-agent.net
RAG_API_URL=https://rag.atlas-agent.net
ALLOWED_ORIGINS=https://app.atlas-agent.net,https://atlas-agent.net

# Twilio (REQUIRED for phone functionality)
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your-actual-twilio-auth-token
TWILIO_API_KEY=SKxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_API_SECRET=your-actual-twilio-api-secret
TWILIO_APP_SID=APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+1234567890

# AI Services (REQUIRED)
OPENAI_API_KEY=sk-your-actual-openai-api-key
GROQ_API_KEY=gsk_your-actual-groq-api-key

# Speech Services (REQUIRED)
ASSEMBLYAI_API_KEY=your-actual-assemblyai-api-key
AZURE_SPEECH_KEY=your-actual-azure-speech-key
AZURE_SPEECH_REGION=eastus
ELEVENLABS_API_KEY=your-actual-elevenlabs-api-key
ELEVENLABS_VOICE_ID=21m00Tcm4TlvDq8ikWAM

# AWS Services (REQUIRED)
AWS_ACCESS_KEY_ID=your-actual-aws-access-key
AWS_SECRET_ACCESS_KEY=your-actual-aws-secret-key
AWS_REGION=us-east-1

# Google Services (REQUIRED)
GOOGLE_CLIENT_ID=your-actual-google-client-id.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-actual-google-client-secret
```

### Optional Variables:
```
AI_FLOW_API_KEY=your-ai-flow-key
JWT_EXPIRATION=24h
SESSION_EXPIRATION=86400000
```

## 🔧 Supabase Setup (REQUIRED)

Before deploying, you must set up Supabase authentication:

1. **Get Supabase Credentials** from your project dashboard:
   - Project URL
   - Anon (public) key
   - Service role (secret) key
   - JWT Secret

2. **Configure Authentication** in Supabase:
   - Set Site URL to: `https://app.yourdomain.com`
   - Add Redirect URLs:
     - `https://app.yourdomain.com/auth/callback`
     - `https://api.yourdomain.com/auth/callback`

3. **Set up Database Schema** (see SUPABASE_AUTH_SETUP.md for details)

📚 **See SUPABASE_AUTH_SETUP.md for complete Supabase configuration guide**

## 2. Domain Configuration ✅

The domains are already configured for `atlas-agent.net`:

- `app.atlas-agent.net` → Frontend
- `api.atlas-agent.net` → Backend API
- `rag.atlas-agent.net` → RAG API

## 3. DNS & SSL ✅

Since you're using the wildcard domain `*.atlas-agent.net` with Cloudflare certificates, DNS and SSL are already configured through Dokploy's Traefik setup.

## 4. Redeploy

After configuring the environment variables in Dokploy UI, redeploy the application.

## 5. Access Your Application

- Frontend: `https://app.atlas-agent.net`
- Backend API: `https://api.atlas-agent.net/health`
- RAG API: `https://rag.atlas-agent.net/health`

## Troubleshooting

If you still get errors:
1. Check Dokploy logs for specific error messages
2. Ensure all environment variables are set correctly
3. Verify DNS records are propagated
4. Check that your domain is accessible from the internet
