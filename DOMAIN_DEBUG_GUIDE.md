# 🚨 Domain Issues Debug Guide

## Current Issues:
1. **app.atlas-agent.net** - Shows "404 page not found"
2. **api.atlas-agent.net** - Doesn't work at all

## 🔍 Immediate Diagnostic Steps

### 1. Check Container Status in Dokploy
```bash
# SSH into your server and check:
docker ps | grep intervo
docker logs <frontend-container-name>
docker logs <backend-container-name>
```

### 2. Test Internal Connectivity
```bash
# Test if services respond internally
docker exec -it <frontend-container> curl localhost:3000
docker exec -it <backend-container> curl localhost:3003/health
```

### 3. Check Domain DNS
```bash
nslookup app.atlas-agent.net
nslookup api.atlas-agent.net
```

## 🔧 Frontend 404 Fix

### Issue: Route Groups Causing Problems
The 404 error suggests Next.js route groups `(app)` are causing routing issues.

### Solution Applied:
✅ Created direct `/login` route outside route groups
✅ Root page redirects to `/login`
✅ Added AuthProvider to login layout

### Test URLs:
- `https://app.atlas-agent.net/` → Should redirect to login
- `https://app.atlas-agent.net/login` → Should show login page

## 🔧 Backend API Fix

### Issue: API Not Accessible
The API not working suggests container or networking issues.

### Check These:
1. **Container Running**: `docker ps | grep backend`
2. **Health Endpoint**: `curl https://api.atlas-agent.net/health`
3. **Port Binding**: Backend should bind to 0.0.0.0:3003
4. **Environment Variables**: Check if all required env vars are set

### Expected Health Response:
```json
{
  "status": "Server running well",
  "environment": "production",
  "timestamp": "2025-01-23T..."
}
```

## 🎯 Dokploy Configuration Check

### Frontend Service:
- **Domain**: app.atlas-agent.net
- **Port**: 3000
- **Container**: Should be running and accessible
- **SSL**: Let's Encrypt certificate should be valid

### Backend Service:
- **Domain**: api.atlas-agent.net  
- **Port**: 3003
- **Container**: Should be running and accessible
- **SSL**: Let's Encrypt certificate should be valid

## 🚀 Quick Fixes to Try

### 1. Force Rebuild Both Services
In Dokploy dashboard:
- Click "Rebuild" on frontend service
- Click "Rebuild" on backend service
- Wait for both to complete

### 2. Check SSL Certificates
```bash
curl -I https://app.atlas-agent.net
curl -I https://api.atlas-agent.net
```

### 3. Test Without HTTPS
```bash
curl -I http://app.atlas-agent.net
curl -I http://api.atlas-agent.net
```

### 4. Check Traefik Dashboard
If accessible, check Traefik dashboard for:
- Service discovery
- Routing rules
- SSL certificate status

## 🔍 Most Likely Causes

### Frontend 404:
1. **Route groups issue** - ✅ Fixed with direct routes
2. **Build incomplete** - Try rebuilding
3. **AuthProvider missing** - ✅ Fixed with layout
4. **Domain pointing to wrong port** - Check Dokploy config

### Backend Not Working:
1. **Container not starting** - Check logs
2. **Environment variables missing** - Check Dokploy env vars
3. **Port binding issue** - Should bind to 0.0.0.0
4. **SSL certificate issue** - Check Let's Encrypt

## 📋 Step-by-Step Debug Process

### Step 1: Container Status
```bash
docker ps
# Should show both frontend and backend containers running
```

### Step 2: Container Logs
```bash
docker logs <frontend-container> --tail 50
docker logs <backend-container> --tail 50
```

### Step 3: Internal Testing
```bash
# Test from inside containers
docker exec -it <frontend-container> curl localhost:3000
docker exec -it <backend-container> curl localhost:3003/health
```

### Step 4: External Testing
```bash
# Test domains
curl -v https://app.atlas-agent.net
curl -v https://api.atlas-agent.net/health
```

## 🆘 If Still Not Working

1. **Share container logs** from both services
2. **Check Dokploy service status** in dashboard
3. **Verify DNS propagation** with online tools
4. **Test with server IP directly** if possible

The fixes are committed and ready - try rebuilding both services in Dokploy!
