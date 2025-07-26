# 🚀 Dokploy Setup Guide for Intervo

Based on official Dokploy documentation and best practices.

## 📋 Current Configuration Status

### ✅ What's Correctly Configured:
- **Network**: Using `dokploy-network` as external network
- **Volumes**: Using `../files/` prefix for persistent storage
- **Ports**: Using `expose` instead of direct port mapping
- **Dependencies**: Proper service dependencies configured
- **Environment**: Comprehensive environment variable setup

### 🔧 Recent Improvements Made:
- Added Traefik labels for automatic domain routing
- Configured SSL certificates via Let's Encrypt
- Set up proper service names for routing

## 🌐 Domain Configuration

Your services are now configured with these domains:
- **Frontend**: `app.atlas-agent.net` (port 3000)
- **Backend**: `api.atlas-agent.net` (port 3003)
- **RAG API**: `rag.atlas-agent.net` (port 4003)
- **MongoDB**: Internal only (no external access)

## 📝 Dokploy Setup Steps

### 1. Create Docker Compose Service in Dokploy

1. **Login to Dokploy Dashboard** at `https://your-dokploy-server:3000`
2. **Create New Project** (if not exists)
3. **Add New Service** → Select "Compose"
4. **Configure Source**:
   - **Source Type**: Git
   - **Repository**: Your GitHub repository URL
   - **Branch**: `main` (or your deployment branch)
   - **Compose Path**: `./dokploy-docker-compose.yml`

### 2. Environment Variables Setup

In Dokploy, go to **Environment** tab and ensure all variables from `.env.production` are configured:

**Critical Variables**:
```bash
SESSION_SECRET=your-session-secret
NEXTAUTH_SECRET=your-nextauth-secret
ENCRYPTION_KEY=your-encryption-key
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-supabase-anon-key
# ... (all other variables from .env.production)
```

### 3. Domain Configuration

**Option A: Using Dokploy UI (Recommended)**
1. Go to **Domains** tab in your Compose service
2. Click **Add Domain**
3. Configure each service:

**Frontend Domain**:
- Host: `app.atlas-agent.net`
- Path: `/`
- Container Port: `3000`
- HTTPS: `ON`
- Certificate: `Let's Encrypt`

**Backend Domain**:
- Host: `api.atlas-agent.net`
- Path: `/`
- Container Port: `3003`
- HTTPS: `ON`
- Certificate: `Let's Encrypt`

**RAG API Domain**:
- Host: `rag.atlas-agent.net`
- Path: `/`
- Container Port: `4003`
- HTTPS: `ON`
- Certificate: `Let's Encrypt`

**Option B: Using Traefik Labels (Already Configured)**
The docker-compose file now includes Traefik labels for automatic routing.

### 4. DNS Configuration

Ensure your DNS records point to your server:
```
A    app.atlas-agent.net    → YOUR_SERVER_IP
A    api.atlas-agent.net    → YOUR_SERVER_IP
A    rag.atlas-agent.net    → YOUR_SERVER_IP
```

## 🏥 Health Checks & Production Setup

### Health Check Configuration

Add these health checks in Dokploy **Advanced** → **Swarm Settings**:

**Backend Health Check**:
```json
{
  "Test": [
    "CMD",
    "curl",
    "-f",
    "http://localhost:3003/health"
  ],
  "Interval": 30000000000,
  "Timeout": 10000000000,
  "StartPeriod": 30000000000,
  "Retries": 3
}
```

**Frontend Health Check**:
```json
{
  "Test": [
    "CMD",
    "curl",
    "-f",
    "http://localhost:3000/api/health"
  ],
  "Interval": 30000000000,
  "Timeout": 10000000000,
  "StartPeriod": 30000000000,
  "Retries": 3
}
```

### Rollback Configuration

**Update Config** for automatic rollbacks:
```json
{
  "Parallelism": 1,
  "Delay": 10000000000,
  "FailureAction": "rollback",
  "Order": "start-first"
}
```

## 🔄 Deployment Process

### Manual Deployment
1. Go to **Deployments** tab
2. Click **Deploy**
3. Monitor deployment logs

### Auto-Deployment Setup
1. Go to **Deployments** tab
2. Copy the **Webhook URL**
3. Add webhook to your Git repository:
   - **GitHub**: Settings → Webhooks → Add webhook
   - **Payload URL**: Paste the webhook URL
   - **Content type**: `application/json`
   - **Events**: Push events

## 🛠️ Troubleshooting

### Common Issues:

**1. Services not accessible**
- Check if domains are properly configured
- Verify DNS records point to server IP
- Ensure Traefik is running: `docker ps | grep traefik`

**2. Build failures**
- Check if all Dockerfiles exist and are correct
- Verify build contexts in docker-compose.yml
- Monitor build logs in Dokploy

**3. Environment variables not working**
- Ensure all variables are set in Dokploy Environment tab
- Check variable names match exactly
- Verify .env.production is not conflicting

**4. Database connection issues**
- Verify MongoDB service is running
- Check network connectivity between services
- Ensure MongoDB credentials are correct

### Useful Commands:
```bash
# Check running containers
docker ps

# Check service logs
docker logs <container_name>

# Check network connectivity
docker exec -it <container_name> ping mongodb

# Restart Traefik if needed
docker restart dokploy-traefik
```

## 📊 Monitoring

Monitor your services through:
1. **Dokploy Dashboard**: Real-time metrics and logs
2. **Service Health**: Check health endpoints
3. **Resource Usage**: Monitor CPU, memory, disk usage

## 🔐 Security Best Practices

1. **Use strong secrets** for all authentication keys
2. **Enable HTTPS** for all public domains
3. **Restrict database access** to internal network only
4. **Regular backups** of persistent volumes
5. **Monitor logs** for suspicious activity

## 📚 Additional Resources

- [Official Dokploy Documentation](https://docs.dokploy.com)
- [Docker Compose Best Practices](https://docs.dokploy.com/docs/core/docker-compose)
- [Traefik Configuration](https://docs.dokploy.com/docs/core/domains)
- [Production Deployment Guide](https://docs.dokploy.com/docs/core/applications/going-production)
