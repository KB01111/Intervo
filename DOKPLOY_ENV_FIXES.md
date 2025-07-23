# 🔧 Dokploy Environment Configuration Fixes

## 🚨 **Critical Issues Found:**

### **1. Domain Mismatch**
Your env shows `intervo.atlas-agent.net` but you mentioned `app.atlas-agent.net`

### **2. CORS Configuration**
ALLOWED_ORIGINS has formatting issues

### **3. Missing API Keys**
Most services have placeholder keys

## ✅ **Corrected Environment Variables:**

```env
# =============================================================================
# DOKPLOY DOMAIN CONFIGURATION (CORRECTED)
# =============================================================================
# Base application URL
BASE_URL=https://api.atlas-agent.net

# Frontend URL - CORRECTED to match your actual domain
FRONTEND_URL=https://app.atlas-agent.net

# NextAuth URL (for OAuth callbacks)
NEXTAUTH_URL=https://api.atlas-agent.net

# RAG API URL (internal service communication)
RAG_API_URL=http://rag-api:4003

# Allowed origins for CORS - FIXED formatting
ALLOWED_ORIGINS=https://app.atlas-agent.net,https://api.atlas-agent.net,https://rag.atlas-agent.net

# =============================================================================
# NEXT.JS FRONTEND CONFIGURATION
# =============================================================================
# Add these for Next.js to work properly
NEXT_PUBLIC_API_URL=https://api.atlas-agent.net
NEXT_PUBLIC_FRONTEND_URL=https://app.atlas-agent.net
```

## 🔧 **Immediate Fixes Needed:**

### **1. Update Domain Configuration in Dokploy:**

**Frontend Service:**
- Domain: `app.atlas-agent.net` (not `intervo.atlas-agent.net`)
- Port: 3000
- Environment: Update `FRONTEND_URL=https://app.atlas-agent.net`

**Backend Service:**
- Domain: `api.atlas-agent.net`
- Port: 3003
- Environment: Update `ALLOWED_ORIGINS` (remove trailing slash)

### **2. Add Missing Environment Variables:**
```env
# Add these to your Dokploy environment
NEXT_PUBLIC_API_URL=https://api.atlas-agent.net
NEXT_PUBLIC_FRONTEND_URL=https://app.atlas-agent.net
```

### **3. Fix CORS Origins:**
Change from:
```env
ALLOWED_ORIGINS=https://intervo.atlas-agent.net/,https://api.atlas-agent.net,https://rag.atlas-agent.net
```

To:
```env
ALLOWED_ORIGINS=https://app.atlas-agent.net,https://api.atlas-agent.net,https://rag.atlas-agent.net
```

## 🚀 **Step-by-Step Fix Process:**

### **Step 1: Update Environment Variables**
In your Dokploy dashboard:
1. Go to your application settings
2. Update environment variables with the corrected values above
3. Save changes

### **Step 2: Update Domain Configuration**
1. **Frontend Service**: Change domain from `intervo.atlas-agent.net` to `app.atlas-agent.net`
2. **Backend Service**: Ensure domain is `api.atlas-agent.net`
3. **RAG Service**: Ensure domain is `rag.atlas-agent.net` (if needed)

### **Step 3: Rebuild Services**
1. Rebuild frontend service
2. Rebuild backend service
3. Wait for both to complete

### **Step 4: Test Domains**
```bash
# Test frontend
curl -I https://app.atlas-agent.net

# Test backend
curl -I https://api.atlas-agent.net/health
```

## 🔍 **Diagnostic Commands:**

### **Check Container Status:**
```bash
# SSH into your server
docker ps | grep intervo

# Check logs
docker logs <frontend-container-name> --tail 50
docker logs <backend-container-name> --tail 50
```

### **Test Internal Connectivity:**
```bash
# Test from inside containers
docker exec -it <frontend-container> curl localhost:3000
docker exec -it <backend-container> curl localhost:3003/health
```

## ⚠️ **API Keys Issues:**

Your environment has placeholder API keys for:
- Twilio (phone functionality won't work)
- Groq (AI features may fail)
- AssemblyAI (speech recognition won't work)
- Azure Speech (TTS won't work)
- ElevenLabs (voice synthesis won't work)

**For basic functionality, you need at least:**
- Valid OpenAI API key ✅ (you have this)
- Valid Google OAuth credentials (for login)

## 🎯 **Most Likely Fixes:**

1. **Frontend 404**: Domain mismatch + missing NEXT_PUBLIC_API_URL
2. **Backend not working**: CORS configuration + domain mismatch

## 📋 **Quick Fix Checklist:**

- [ ] Update `FRONTEND_URL` to `https://app.atlas-agent.net`
- [ ] Fix `ALLOWED_ORIGINS` (remove trailing slash, correct domain)
- [ ] Add `NEXT_PUBLIC_API_URL=https://api.atlas-agent.net`
- [ ] Update Dokploy domain configuration
- [ ] Rebuild both services
- [ ] Test domains

**Try these fixes first - they should resolve both domain issues!**
