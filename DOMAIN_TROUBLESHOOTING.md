# 🔧 Domain Troubleshooting Guide for Intervo App

## ✅ Issues Fixed

### 1. **Backend Server Binding Issue (CRITICAL FIX)**
- **Problem**: Backend was binding to `localhost` (127.0.0.1) only
- **Solution**: Updated `packages/intervo-backend/server.js` to bind to `0.0.0.0`
- **Change**: `server.listen(port, '0.0.0.0', () => {...})`

### 2. **Port Mapping Consistency**
- **Problem**: Docker compose had inconsistent port mapping `3001:3003`
- **Solution**: Changed to `3003:3003` for clarity
- **Impact**: Backend now accessible on port 3003 both internally and externally

### 3. **Next.js Frontend Binding**
- **Problem**: Next.js might bind to localhost by default
- **Solution**: Added `-H 0.0.0.0` flag to Next.js dev command
- **Change**: `next dev -H 0.0.0.0`

## 🚀 Deployment Checklist for Dokploy

### Before Adding Domain to Dokploy:
1. **Point Domain to Server IP First**
   ```bash
   # Ensure your domain DNS points to your server IP
   # Example: app.atlas-agent.net -> YOUR_SERVER_IP
   ```

2. **Verify Port Configuration**
   - Frontend: Port 3000 ✅
   - Backend: Port 3003 ✅  
   - RAG API: Port 4003 ✅

### In Dokploy Configuration:

#### Frontend Service (app.atlas-agent.net):
- **Port**: 3000
- **Do NOT use**: Ports feature in Advanced Settings
- **Protocol**: HTTP/HTTPS (Let's Encrypt will handle SSL)

#### Backend Service (api.atlas-agent.net):
- **Port**: 3003
- **Do NOT use**: Ports feature in Advanced Settings
- **Protocol**: HTTP/HTTPS (Let's Encrypt will handle SSL)

#### RAG API Service (rag.atlas-agent.net):
- **Port**: 4003
- **Do NOT use**: Ports feature in Advanced Settings
- **Protocol**: HTTP/HTTPS (Let's Encrypt will handle SSL)

### Environment Variables Setup:
1. Copy `.env.production.example` to `.env.production`
2. Update domain URLs:
   ```env
   BASE_URL=https://api.atlas-agent.net
   FRONTEND_URL=https://app.atlas-agent.net
   NEXTAUTH_URL=https://api.atlas-agent.net
   ALLOWED_ORIGINS=https://app.atlas-agent.net,https://api.atlas-agent.net,https://rag.atlas-agent.net
   ```

## 🔍 Troubleshooting Steps

### If Domain Still Not Working:

1. **Check Container Logs**
   ```bash
   docker logs <container_name>
   ```

2. **Verify Binding**
   ```bash
   # Inside container, check if services are listening on 0.0.0.0
   netstat -tlnp | grep :3000  # Frontend
   netstat -tlnp | grep :3003  # Backend
   netstat -tlnp | grep :4003  # RAG API
   ```

3. **Test Internal Connectivity**
   ```bash
   # From within Docker network
   curl http://frontend:3000/health
   curl http://backend:3003/health
   curl http://rag-api:4003/health
   ```

4. **Check Traefik Configuration**
   - Ensure Traefik is running
   - Check Traefik dashboard for service discovery
   - Verify SSL certificate generation

### Common Issues & Solutions:

#### Issue: "Connection Refused"
- **Cause**: Service binding to 127.0.0.1 instead of 0.0.0.0
- **Solution**: ✅ Already fixed in this update

#### Issue: "SSL Certificate Not Generated"
- **Cause**: Domain added to Dokploy before DNS propagation
- **Solution**: 
  1. Remove domain from Dokploy
  2. Wait for DNS propagation (use `dig app.atlas-agent.net`)
  3. Re-add domain to Dokploy

#### Issue: "502 Bad Gateway"
- **Cause**: Backend service not responding
- **Solution**: Check backend logs and ensure MongoDB connection

## 📁 Files Updated:
- ✅ `packages/intervo-backend/server.js` - Fixed binding to 0.0.0.0
- ✅ `docker-compose.yml` - Fixed port mapping and Next.js binding
- ✅ Created production Dockerfiles
- ✅ Created `docker-compose.prod.yml` for production deployment

## 🎯 Next Steps:
1. Test the updated configuration locally
2. Deploy to Dokploy using the production docker-compose
3. Add domains in the correct order (DNS first, then Dokploy)
4. Monitor logs for any remaining issues
