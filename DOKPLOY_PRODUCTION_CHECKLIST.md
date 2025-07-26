# ✅ Dokploy Production Deployment Checklist

## 🔍 Pre-Deployment Verification

### ✅ Configuration Files
- [ ] `dokploy-docker-compose.yml` - Updated with Traefik labels
- [ ] `Dockerfile.dokploy` - Frontend Dockerfile exists
- [ ] `packages/intervo-backend/Dockerfile.prod` - Backend Dockerfile exists  
- [ ] `packages/intervo-backend/rag_py/Dockerfile.prod` - RAG API Dockerfile exists
- [ ] `.env.production` - All environment variables configured

### ✅ Docker Compose Validation
- [ ] Run `docker-compose -f dokploy-docker-compose.yml config` ✅ (Passed)
- [ ] All services use `dokploy-network`
- [ ] Volumes use `../files/` prefix for persistence
- [ ] Services use `expose` instead of `ports` mapping
- [ ] Traefik labels configured for all public services

### ✅ Environment Variables
- [ ] `SESSION_SECRET` - 32+ character random string
- [ ] `NEXTAUTH_SECRET` - 32+ character random string  
- [ ] `ENCRYPTION_KEY` - Exactly 32 characters
- [ ] `SUPABASE_URL` - Your Supabase project URL
- [ ] `SUPABASE_ANON_KEY` - Supabase anonymous key
- [ ] `SUPABASE_SERVICE_ROLE_KEY` - Supabase service role key
- [ ] All API keys (OpenAI, Groq, Twilio, etc.) configured
- [ ] Domain URLs correctly set:
  - `BASE_URL=https://api.atlas-agent.net`
  - `FRONTEND_URL=https://app.atlas-agent.net`
  - `NEXTAUTH_URL=https://api.atlas-agent.net`

## 🌐 DNS & Domain Setup

### ✅ DNS Records
- [ ] `A app.atlas-agent.net → YOUR_SERVER_IP`
- [ ] `A api.atlas-agent.net → YOUR_SERVER_IP`  
- [ ] `A rag.atlas-agent.net → YOUR_SERVER_IP`
- [ ] DNS propagation completed (check with `nslookup`)

### ✅ SSL Certificates
- [ ] Let's Encrypt configured in Dokploy
- [ ] HTTPS enabled for all domains
- [ ] Certificate auto-renewal enabled

## 🚀 Dokploy Configuration

### ✅ Service Setup
- [ ] Create new Compose service in Dokploy
- [ ] Set repository URL and branch
- [ ] Set compose path: `./dokploy-docker-compose.yml`
- [ ] Configure all environment variables in Dokploy UI

### ✅ Domain Configuration
**Frontend (app.atlas-agent.net)**:
- [ ] Host: `app.atlas-agent.net`
- [ ] Path: `/`
- [ ] Container Port: `3000`
- [ ] HTTPS: `ON`
- [ ] Certificate: `Let's Encrypt`

**Backend (api.atlas-agent.net)**:
- [ ] Host: `api.atlas-agent.net`
- [ ] Path: `/`
- [ ] Container Port: `3003`
- [ ] HTTPS: `ON`
- [ ] Certificate: `Let's Encrypt`

**RAG API (rag.atlas-agent.net)**:
- [ ] Host: `rag.atlas-agent.net`
- [ ] Path: `/`
- [ ] Container Port: `4003`
- [ ] HTTPS: `ON`
- [ ] Certificate: `Let's Encrypt`

## 🏥 Health Checks & Monitoring

### ✅ Health Endpoints
- [ ] Backend health endpoint: `/health` (port 3003)
- [ ] Frontend health endpoint: `/api/health` (port 3000)
- [ ] RAG API health endpoint: `/health` (port 4003)

### ✅ Dokploy Health Check Configuration
**Backend Health Check**:
```json
{
  "Test": ["CMD", "curl", "-f", "http://localhost:3003/health"],
  "Interval": 30000000000,
  "Timeout": 10000000000,
  "StartPeriod": 30000000000,
  "Retries": 3
}
```

**Frontend Health Check**:
```json
{
  "Test": ["CMD", "curl", "-f", "http://localhost:3000/api/health"],
  "Interval": 30000000000,
  "Timeout": 10000000000,
  "StartPeriod": 30000000000,
  "Retries": 3
}
```

**RAG API Health Check**:
```json
{
  "Test": ["CMD", "curl", "-f", "http://localhost:4003/health"],
  "Interval": 30000000000,
  "Timeout": 10000000000,
  "StartPeriod": 30000000000,
  "Retries": 3
}
```

### ✅ Rollback Configuration
```json
{
  "Parallelism": 1,
  "Delay": 10000000000,
  "FailureAction": "rollback",
  "Order": "start-first"
}
```

## 🔄 Deployment Process

### ✅ Initial Deployment
- [ ] Deploy via Dokploy UI
- [ ] Monitor deployment logs
- [ ] Verify all services start successfully
- [ ] Test all domain endpoints

### ✅ Auto-Deployment Setup
- [ ] Copy webhook URL from Dokploy
- [ ] Add webhook to GitHub repository
- [ ] Test auto-deployment with a commit

## 🧪 Testing & Verification

### ✅ Service Health Tests
```bash
# Test health endpoints
curl https://api.atlas-agent.net/health
curl https://app.atlas-agent.net/api/health  
curl https://rag.atlas-agent.net/health
```

### ✅ Functionality Tests
- [ ] Frontend loads correctly
- [ ] Backend API responds
- [ ] Database connectivity works
- [ ] RAG API processes requests
- [ ] Authentication flows work
- [ ] File uploads work (if applicable)

### ✅ Performance Tests
- [ ] Response times acceptable
- [ ] Memory usage within limits
- [ ] CPU usage reasonable
- [ ] Disk space sufficient

## 🔐 Security Checklist

### ✅ Access Control
- [ ] MongoDB not exposed externally
- [ ] Strong passwords for all services
- [ ] API keys properly secured
- [ ] HTTPS enforced for all public endpoints

### ✅ Data Protection
- [ ] Sensitive data encrypted
- [ ] Backup strategy in place
- [ ] Log rotation configured
- [ ] File permissions correct

## 📊 Monitoring & Maintenance

### ✅ Monitoring Setup
- [ ] Dokploy dashboard monitoring enabled
- [ ] Log aggregation configured
- [ ] Alert notifications set up
- [ ] Resource usage monitoring

### ✅ Backup Strategy
- [ ] Database backups automated
- [ ] Volume backups configured
- [ ] Configuration backups stored
- [ ] Recovery procedures documented

## 🚨 Troubleshooting Commands

```bash
# Check running containers
docker ps

# Check service logs
docker logs <container_name>

# Check network connectivity
docker exec -it <container_name> ping mongodb

# Restart Traefik if needed
docker restart dokploy-traefik

# Check Dokploy services
docker service ls | grep dokploy
```

## 📝 Post-Deployment Tasks

### ✅ Documentation
- [ ] Update deployment documentation
- [ ] Document any custom configurations
- [ ] Create runbook for common issues
- [ ] Update team on new deployment process

### ✅ Team Handover
- [ ] Share Dokploy dashboard access
- [ ] Provide deployment credentials
- [ ] Train team on monitoring tools
- [ ] Document escalation procedures

## 🎯 Success Criteria

- [ ] All services accessible via HTTPS
- [ ] Health checks passing
- [ ] Auto-deployment working
- [ ] Monitoring active
- [ ] Backups configured
- [ ] Team trained

---

## 📞 Support Resources

- **Dokploy Documentation**: https://docs.dokploy.com
- **Docker Compose Reference**: https://docs.dokploy.com/docs/core/docker-compose
- **Troubleshooting Guide**: https://docs.dokploy.com/docs/core/troubleshooting
- **Community Discord**: https://discord.com/invite/2tBnJ3jDJc

---

**Deployment Date**: ___________  
**Deployed By**: ___________  
**Verified By**: ___________
