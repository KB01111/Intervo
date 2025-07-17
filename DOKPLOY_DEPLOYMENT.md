# Dokploy Deployment Guide for Intervo

This guide provides step-by-step instructions for deploying the Intervo application on Dokploy with automatic domain setup and SSL certificates.

## 🚀 Quick Start

1. **Prepare your environment**
2. **Deploy to Dokploy**
3. **Configure DNS records**
4. **Access your application**

## 📋 Prerequisites

- Dokploy server installed and running
- Domain name with DNS management access
- Environment variables configured

## 🔧 Step 1: Environment Configuration

1. Copy the environment template:
```bash
cp .env.production.example .env.production
```

2. Edit `.env.production` and fill in your actual values:
   - Replace `yourdomain.com` with your actual domain
   - Add your API keys (OpenAI, Twilio, etc.)
   - Set secure JWT and session secrets
   - Configure database credentials

## 🌐 Step 2: DNS Configuration

Configure the following DNS A records pointing to your Dokploy server IP:

```
A    app.yourdomain.com    → YOUR_SERVER_IP
A    api.yourdomain.com    → YOUR_SERVER_IP  
A    rag.yourdomain.com    → YOUR_SERVER_IP
```

**Example with IP 1.2.3.4:**
```
A    app.intervo.ai    → 1.2.3.4
A    api.intervo.ai    → 1.2.3.4
A    rag.intervo.ai    → 1.2.3.4
```

## 📦 Step 3: Deploy to Dokploy

### Option A: Using Dokploy UI

1. **Login to Dokploy Dashboard**
   - Go to `http://YOUR_SERVER_IP:3000`
   - Login with your credentials

2. **Create New Docker Compose Project**
   - Click "Create Project"
   - Select "Docker Compose"
   - Name: `intervo-production`

3. **Upload Configuration**
   - Upload `dokploy-docker-compose.yml`
   - Set environment variables from `.env.production`

4. **Deploy**
   - Click "Deploy"
   - Monitor deployment logs

### Option B: Using Git Repository

1. **Connect Repository**
   - In Dokploy, create new Docker Compose project
   - Connect your Git repository
   - Set branch to `main` or your production branch

2. **Configure Build**
   - Set Docker Compose file path: `dokploy-docker-compose.yml`
   - Configure environment variables

3. **Deploy**
   - Click "Deploy"
   - Enable auto-deploy for future updates

## 🔒 Step 4: SSL Certificate Setup

SSL certificates are automatically configured via Let's Encrypt through the Traefik labels in the Docker Compose file. The certificates will be issued automatically when:

1. DNS records are properly configured
2. Domains are accessible from the internet
3. Dokploy deployment is successful

## 🏗️ Architecture Overview

The deployment creates the following services:

### Frontend (app.yourdomain.com)
- **Service**: Next.js application
- **Port**: 3000 (internal)
- **Features**: Static assets, SSR, client-side routing

### Backend API (api.yourdomain.com)
- **Service**: Node.js Express server
- **Port**: 3003 (internal)
- **Features**: REST API, authentication, business logic

### RAG API (rag.yourdomain.com)
- **Service**: Python FastAPI server
- **Port**: 4003 (internal)
- **Features**: AI/ML processing, vector search

### Database (Internal Only)
- **Service**: MongoDB
- **Port**: 27017 (internal only)
- **Features**: Data persistence, user management

## 📁 File Structure

```
/application-name/
├── code/                          # Your application code
│   ├── dokploy-docker-compose.yml
│   ├── Dockerfile.frontend.prod
│   ├── packages/
│   │   └── intervo-backend/
│   │       ├── Dockerfile.prod
│   │       └── rag_py/
│   │           └── Dockerfile.prod
│   └── .env.production
└── files/                         # Persistent data
    ├── mongodb_data/              # Database files
    ├── frontend_cache/            # Next.js cache
    ├── backend_logs/              # Application logs
    ├── backend_uploads/           # File uploads
    ├── rag_cache/                 # Python cache
    └── vector_stores/             # AI vector data
```

## 🔍 Health Checks & Monitoring

The deployment includes health checks for zero-downtime deployments:

- **Frontend**: `GET /api/health`
- **Backend**: `GET /health`
- **RAG API**: `GET /health`

## 🚨 Troubleshooting

### Common Issues

1. **SSL Certificate Not Issued**
   - Verify DNS records are correct
   - Check domain accessibility from internet
   - Wait 5-10 minutes for propagation

2. **Service Not Starting**
   - Check Dokploy logs
   - Verify environment variables
   - Ensure all required API keys are set

3. **Database Connection Issues**
   - Verify MongoDB service is running
   - Check network connectivity
   - Validate connection string

### Useful Commands

```bash
# Check running containers
docker ps

# View service logs
docker logs <container_name>

# Check network connectivity
docker exec -it <container_name> ping mongodb

# Restart services
docker-compose restart <service_name>
```

## 🔄 Updates & Maintenance

### Automatic Updates
- Enable auto-deploy in Dokploy for automatic updates on git push
- Configure webhooks for CI/CD integration

### Manual Updates
1. Update your code repository
2. In Dokploy dashboard, click "Redeploy"
3. Monitor deployment progress

### Backup Strategy
- Database: Automated backups via Dokploy
- Files: Regular backup of `/files` directory
- Configuration: Version control for Docker Compose and environment files

## 🛡️ Security Considerations

1. **Environment Variables**: Never commit `.env.production` to version control
2. **API Keys**: Use secure, unique keys for each service
3. **Database**: Change default MongoDB credentials
4. **SSL**: Ensure all traffic uses HTTPS
5. **Firewall**: Only expose necessary ports (80, 443)

## 📞 Support

For deployment issues:
1. Check Dokploy documentation
2. Review application logs
3. Verify DNS and SSL configuration
4. Contact your system administrator

---

**Note**: Replace `yourdomain.com` with your actual domain throughout this guide.
