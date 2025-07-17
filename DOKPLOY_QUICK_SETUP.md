# Dokploy Quick Setup Guide

## 🚨 Fix for Current Deployment Error

The deployment failed due to missing environment variables. Here's how to fix it:

## 1. Configure Environment Variables in Dokploy UI

In your Dokploy dashboard, go to your project settings and add these environment variables:

### Required Variables (Replace with your actual values):

```
SESSION_SECRET=your-super-secret-session-key-minimum-32-characters
NEXTAUTH_SECRET=your-jwt-secret-key-minimum-32-characters
ENCRYPTION_KEY=your-encryption-key-exactly-32-chars

TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=your-actual-twilio-auth-token
TWILIO_API_KEY=SKxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_API_SECRET=your-actual-twilio-api-secret
TWILIO_APP_SID=APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_PHONE_NUMBER=+1234567890

OPENAI_API_KEY=sk-your-actual-openai-api-key
GROQ_API_KEY=gsk_your-actual-groq-api-key

ASSEMBLYAI_API_KEY=your-actual-assemblyai-api-key
AZURE_SPEECH_KEY=your-actual-azure-speech-key
AZURE_SPEECH_REGION=eastus
ELEVENLABS_API_KEY=your-actual-elevenlabs-api-key
ELEVENLABS_VOICE_ID=21m00Tcm4TlvDq8ikWAM

AWS_ACCESS_KEY_ID=your-actual-aws-access-key
AWS_SECRET_ACCESS_KEY=your-actual-aws-secret-key
AWS_REGION=us-east-1

GOOGLE_CLIENT_ID=your-actual-google-client-id.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-actual-google-client-secret
```

### Optional Variables:
```
AI_FLOW_API_KEY=your-ai-flow-key
```

## 2. Update Domain Configuration

In the `dokploy-docker-compose.yml` file, replace `yourdomain.com` with your actual domain:

- `app.yourdomain.com` → `app.youractualdomain.com`
- `api.yourdomain.com` → `api.youractualdomain.com`
- `rag.yourdomain.com` → `rag.youractualdomain.com`

## 3. DNS Configuration

Set up these A records pointing to your Dokploy server IP:
```
A    app.youractualdomain.com    → YOUR_DOKPLOY_SERVER_IP
A    api.youractualdomain.com    → YOUR_DOKPLOY_SERVER_IP
A    rag.youractualdomain.com    → YOUR_DOKPLOY_SERVER_IP
```

## 4. Redeploy

After configuring the environment variables in Dokploy UI, redeploy the application.

## 5. Access Your Application

- Frontend: `https://app.youractualdomain.com`
- Backend API: `https://api.youractualdomain.com/health`
- RAG API: `https://rag.youractualdomain.com/health`

## Troubleshooting

If you still get errors:
1. Check Dokploy logs for specific error messages
2. Ensure all environment variables are set correctly
3. Verify DNS records are propagated
4. Check that your domain is accessible from the internet
