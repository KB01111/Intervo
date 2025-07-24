# Dokploy Native Domain Setup Guide

## 🔍 **Root Cause of Domain Issues**

The domains weren't working because we were using **both approaches simultaneously**:
1. **Manual Traefik Labels** (in docker-compose.yml) - Old method
2. **Native Domain Feature** (in Dokploy UI) - New recommended method since v0.7.0

This created conflicts where both systems competed for the same domain routing.

## ✅ **Solution: Use Native Domain Feature Only**

According to Dokploy documentation:
> **"Since v0.7.0 Dokploy support domains natively. This means that you can configure your domain directly in the Dokploy UI, without doing the rest of the steps"**

## 🔧 **Updated Docker Compose Configuration**

The docker-compose.yml now uses the **clean approach**:
- ✅ **Network**: `dokploy-network` (required)
- ✅ **Expose**: Ports exposed internally (required)
- ❌ **No Traefik Labels**: Removed all manual labels
- ❌ **No Ports**: Using `expose:` not `ports:`

## 🌐 **Domain Configuration in Dokploy UI**

### Step 1: Prerequisites
1. **DNS A Records** must point to your server IP:
   ```
   app.atlas-agent.net  → YOUR_SERVER_IP
   api.atlas-agent.net  → YOUR_SERVER_IP
   rag.atlas-agent.net  → YOUR_SERVER_IP
   ```

2. **Verify DNS Propagation**:
   ```bash
   nslookup app.atlas-agent.net
   dig app.atlas-agent.net
   ```

### Step 2: Add Domains in Dokploy UI

Navigate to your Docker Compose application → **Domains** section and add:

#### Domain 1: Frontend
- **Host**: `app.atlas-agent.net`
- **Path**: `/` (leave empty)
- **Container Port**: `3000`
- **HTTPS**: ✅ **Enabled**
- **Certificate**: `letsencrypt`

#### Domain 2: Backend API
- **Host**: `api.atlas-agent.net`
- **Path**: `/` (leave empty)
- **Container Port**: `3003`
- **HTTPS**: ✅ **Enabled**
- **Certificate**: `letsencrypt`

#### Domain 3: RAG API
- **Host**: `rag.atlas-agent.net`
- **Path**: `/` (leave empty)
- **Container Port**: `4003`
- **HTTPS**: ✅ **Enabled**
- **Certificate**: `letsencrypt`

### Step 3: Important Settings

#### ❌ **DO NOT Configure in Advanced Settings**:
- **Ports Section**: Leave empty (conflicts with domains)
- **Manual Port Mappings**: Not needed

#### ✅ **Container Port Explanation**:
The "Container Port" in domain settings is for **Traefik routing only**, not direct exposure. This tells Traefik which internal port to route traffic to.

## 🚀 **Deployment Process**

1. **Deploy Updated Docker Compose**:
   - Use the cleaned `dokploy-docker-compose.yml`
   - No Traefik labels = no conflicts

2. **Add Domains in UI**:
   - Add all three domains as specified above
   - Enable HTTPS with Let's Encrypt

3. **Wait for SSL Certificates**:
   - Let's Encrypt will automatically generate certificates
   - This may take a few minutes

## 🧪 **Testing**

### Test HTTP → HTTPS Redirect:
```bash
curl -I http://app.atlas-agent.net
# Should return 301/302 redirect to HTTPS
```

### Test HTTPS Access:
```bash
curl -I https://app.atlas-agent.net
curl -I https://api.atlas-agent.net
curl -I https://rag.atlas-agent.net
# Should all return 200 OK
```

### Test in Browser:
- Frontend: https://app.atlas-agent.net
- Backend: https://api.atlas-agent.net
- RAG API: https://rag.atlas-agent.net/health

## 🔍 **Troubleshooting**

### If Domains Still Don't Work:

1. **Check DNS First**:
   ```bash
   dig app.atlas-agent.net
   # Should return your server IP
   ```

2. **Verify Container Health**:
   ```bash
   docker ps
   docker logs <container-name>
   ```

3. **Check Traefik Dashboard**:
   - Access Traefik dashboard (if enabled)
   - Verify routers are created for your domains

4. **Check Dokploy Logs**:
   ```bash
   docker logs dokploy-traefik
   ```

### Common Issues:

- **DNS not propagated**: Wait 24-48 hours for full propagation
- **Firewall blocking**: Ensure ports 80/443 are open
- **Certificate generation failed**: Check Let's Encrypt rate limits
- **Container not binding to 0.0.0.0**: Already fixed in your config

## 📋 **Key Differences from Manual Approach**

| Manual Traefik Labels | Native Domain Feature |
|----------------------|----------------------|
| ❌ Complex configuration | ✅ Simple UI configuration |
| ❌ Manual HTTPS setup | ✅ Automatic Let's Encrypt |
| ❌ Potential conflicts | ✅ No conflicts |
| ❌ Hard to maintain | ✅ Easy to manage |
| ❌ Error-prone | ✅ Reliable |

## 🎯 **Expected Results**

After following this guide:
- ✅ All three domains should be accessible via HTTPS
- ✅ HTTP traffic automatically redirects to HTTPS
- ✅ SSL certificates automatically managed
- ✅ No configuration conflicts
- ✅ Easy to manage through Dokploy UI

---

**Status**: ✅ **READY FOR NATIVE DOMAIN DEPLOYMENT**

Your Docker Compose is now configured for Dokploy's native domain feature!
