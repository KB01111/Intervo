# 🔧 Build & 404 Error Troubleshooting Guide

## ✅ Issues Fixed

### 1. **Next.js Standalone Build Errors**
- **Problem**: ENOENT copyfile errors with route groups and standalone build
- **Solution**: ✅ Disabled standalone mode, created simple Dockerfile
- **Impact**: Build completes without file copying errors

### 2. **Missing Root Page**
- **Problem**: No `page.js` in root `src/app` directory
- **Solution**: ✅ Created `packages/intervo-frontend/src/app/page.js`
- **Impact**: Provides a working root route that redirects to login

### 3. **Build Process Issues**
- **Problem**: Widget must be built before frontend
- **Solution**: ✅ Created `build-all.sh` comprehensive build script
- **Impact**: Ensures correct build order and dependencies

## 🔍 Common 404 Causes & Solutions

### Issue 1: "404 Page Not Found" on Domain Root
- **Cause**: Missing root page.js file
- **Solution**: ✅ Fixed - Added root page with redirect logic

### Issue 2: "404 on All Routes"
- **Cause**: Frontend not built or build incomplete
- **Solution**: Run the comprehensive build process

### Issue 3: "Domain Points to Wrong Service"
- **Cause**: Dokploy domain configuration
- **Solution**: Verify domain points to correct port

## 🚀 Step-by-Step Fix Process

### Step 1: Build Everything Correctly
```bash
# Run the comprehensive build script
./build-all.sh

# Or manually:
npm install --legacy-peer-deps
npm run build --workspace=intervo-widget
npm run build --workspace=intervo-frontend
```

### Step 2: Test Locally First
```bash
# Start all services
docker-compose down
docker-compose up --build

# Test each service:
curl http://localhost:3000        # Frontend
curl http://localhost:3003/health # Backend  
curl http://localhost:4003/health # RAG API
```

### Step 3: Check Dokploy Configuration

#### Frontend Domain (app.atlas-agent.net):
- **Port**: 3000 ✅
- **Service**: frontend container
- **Path**: / (root)
- **SSL**: Let's Encrypt enabled

#### Backend Domain (api.atlas-agent.net):
- **Port**: 3003 ✅  
- **Service**: backend container
- **Path**: / (root)
- **SSL**: Let's Encrypt enabled

### Step 4: Verify DNS & SSL
```bash
# Check DNS resolution
nslookup app.atlas-agent.net
nslookup api.atlas-agent.net

# Check SSL certificate
curl -I https://app.atlas-agent.net
curl -I https://api.atlas-agent.net
```

## 🔧 Dokploy Specific Fixes

### If Frontend Shows 404:

1. **Check Container Logs**:
   ```bash
   # In Dokploy or via SSH
   docker logs <frontend-container-name>
   ```

2. **Verify Build Output**:
   - Ensure `.next` folder exists and has content
   - Check for build errors in logs

3. **Check Domain Configuration**:
   - Domain points to port 3000
   - No conflicting port mappings
   - SSL certificate generated successfully

### If Backend Shows 404:

1. **Check Health Endpoint**:
   ```bash
   curl https://api.atlas-agent.net/health
   ```

2. **Verify Routes**:
   - Backend should respond on port 3003
   - Check if server is binding to 0.0.0.0 (✅ fixed)

## 🎯 Quick Diagnostic Commands

### Test Frontend Routes:
```bash
# Root page (should redirect to /login)
curl -L https://app.atlas-agent.net/

# Login page
curl https://app.atlas-agent.net/login

# Health check (if available)
curl https://app.atlas-agent.net/api/health
```

### Test Backend Routes:
```bash
# Health endpoint
curl https://api.atlas-agent.net/health

# Auth endpoints
curl https://api.atlas-agent.net/auth/status
```

## 🔄 Rebuild & Redeploy Process

### For Dokploy:

1. **Update Code**:
   ```bash
   git pull origin main
   ```

2. **Rebuild Containers**:
   - In Dokploy: Click "Rebuild" on each service
   - Or via CLI: `docker-compose up --build`

3. **Check Logs**:
   - Monitor startup logs for errors
   - Verify all services start successfully

4. **Test Domains**:
   - Wait for SSL certificates to generate
   - Test each domain individually

## 📋 Checklist for 404 Resolution

- ✅ Root page.js exists in frontend
- ✅ Widget built before frontend
- ✅ Frontend build completed successfully
- ✅ Backend binding to 0.0.0.0
- ✅ All containers starting without errors
- ⏳ DNS pointing to correct server IP
- ⏳ Dokploy domains configured correctly
- ⏳ SSL certificates generated
- ⏳ No port conflicts

## 🆘 If Still Getting 404

1. **Check Traefik Dashboard** (if accessible):
   - Verify service discovery
   - Check routing rules

2. **SSH into Server**:
   ```bash
   # Check if containers are running
   docker ps
   
   # Check container logs
   docker logs <container-name>
   
   # Test internal connectivity
   docker exec -it <frontend-container> curl localhost:3000
   ```

3. **Contact Support**:
   - Provide container logs
   - Share Dokploy configuration
   - Include DNS/SSL status
