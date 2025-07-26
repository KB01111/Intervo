# 🏥 Health Check Endpoints for Intervo Services

## Backend Health Check (Node.js)

Add this to your backend server (e.g., in `packages/intervo-backend/server.js` or routes):

```javascript
// Health check endpoint
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    const dbStatus = await checkDatabaseConnection();
    
    // Check essential services
    const checks = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      database: dbStatus ? 'connected' : 'disconnected',
      memory: process.memoryUsage(),
      environment: process.env.NODE_ENV || 'development'
    };

    // If database is down, return unhealthy status
    if (!dbStatus) {
      checks.status = 'unhealthy';
      return res.status(503).json(checks);
    }

    res.status(200).json(checks);
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      error: error.message
    });
  }
});

// Database connection check function
async function checkDatabaseConnection() {
  try {
    // For MongoDB with Mongoose
    if (mongoose.connection.readyState === 1) {
      return true;
    }
    
    // Alternative: Direct MongoDB connection check
    // const client = new MongoClient(process.env.MONGO_URI);
    // await client.db().admin().ping();
    // await client.close();
    
    return false;
  } catch (error) {
    console.error('Database health check failed:', error);
    return false;
  }
}
```

## Frontend Health Check (Next.js)

Create `packages/intervo-frontend/pages/api/health.js` (or `app/api/health/route.js` for App Router):

```javascript
// For Pages Router (pages/api/health.js)
export default function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ message: 'Method not allowed' });
  }

  try {
    const healthCheck = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'development',
      version: process.env.npm_package_version || '1.0.0',
      backend_url: process.env.NEXT_PUBLIC_API_URL_PRODUCTION || 'not configured'
    };

    res.status(200).json(healthCheck);
  } catch (error) {
    res.status(503).json({
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      error: error.message
    });
  }
}

// For App Router (app/api/health/route.js)
import { NextResponse } from 'next/server';

export async function GET() {
  try {
    const healthCheck = {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      uptime: process.uptime(),
      environment: process.env.NODE_ENV || 'development',
      version: process.env.npm_package_version || '1.0.0',
      backend_url: process.env.NEXT_PUBLIC_API_URL_PRODUCTION || 'not configured'
    };

    return NextResponse.json(healthCheck, { status: 200 });
  } catch (error) {
    return NextResponse.json({
      status: 'unhealthy',
      timestamp: new Date().toISOString(),
      error: error.message
    }, { status: 503 });
  }
}
```

## RAG API Health Check (Python)

Add this to your RAG API (e.g., in `packages/intervo-backend/rag_py/start_api.py`):

```python
from fastapi import FastAPI, HTTPException
from datetime import datetime
import psutil
import os

app = FastAPI()

@app.get("/health")
async def health_check():
    try:
        # Get system information
        memory_info = psutil.virtual_memory()
        disk_info = psutil.disk_usage('/')
        
        health_data = {
            "status": "healthy",
            "timestamp": datetime.utcnow().isoformat(),
            "environment": os.getenv("ENVIRONMENT", "development"),
            "python_version": f"{psutil.sys.version_info.major}.{psutil.sys.version_info.minor}",
            "memory": {
                "total": memory_info.total,
                "available": memory_info.available,
                "percent": memory_info.percent
            },
            "disk": {
                "total": disk_info.total,
                "free": disk_info.free,
                "percent": (disk_info.used / disk_info.total) * 100
            },
            "backend_url": os.getenv("BACKEND_URL", "not configured")
        }
        
        # Check if critical resources are available
        if memory_info.percent > 90 or (disk_info.used / disk_info.total) * 100 > 90:
            health_data["status"] = "degraded"
            health_data["warnings"] = []
            
            if memory_info.percent > 90:
                health_data["warnings"].append("High memory usage")
            
            if (disk_info.used / disk_info.total) * 100 > 90:
                health_data["warnings"].append("High disk usage")
        
        return health_data
        
    except Exception as e:
        raise HTTPException(
            status_code=503,
            detail={
                "status": "unhealthy",
                "timestamp": datetime.utcnow().isoformat(),
                "error": str(e)
            }
        )

# Alternative simple health check
@app.get("/ping")
async def ping():
    return {"status": "pong", "timestamp": datetime.utcnow().isoformat()}
```

## Docker Health Check Configuration

Update your Dockerfiles to include health checks:

### Backend Dockerfile Health Check
Add to `packages/intervo-backend/Dockerfile.prod`:

```dockerfile
# Add curl for health checks (if not already present)
RUN apk add --no-cache curl

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:3003/health || exit 1
```

### Frontend Dockerfile Health Check
Add to `Dockerfile.dokploy`:

```dockerfile
# Add curl for health checks (if not already present)
RUN apk add --no-cache curl

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:3000/api/health || exit 1
```

### RAG API Dockerfile Health Check
Add to `packages/intervo-backend/rag_py/Dockerfile.prod`:

```dockerfile
# Health check (curl should already be installed)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
  CMD curl -f http://localhost:4003/health || exit 1
```

## Testing Health Checks

Test your health endpoints locally:

```bash
# Backend
curl http://localhost:3003/health

# Frontend
curl http://localhost:3000/api/health

# RAG API
curl http://localhost:4003/health
```

Test in production:

```bash
# Backend
curl https://api.atlas-agent.net/health

# Frontend
curl https://app.atlas-agent.net/api/health

# RAG API
curl https://rag.atlas-agent.net/health
```

## Dokploy Health Check Configuration

In Dokploy Dashboard → Advanced → Swarm Settings:

### Health Check JSON Configuration:

```json
{
  "Test": [
    "CMD",
    "curl",
    "-f",
    "http://localhost:PORT/health"
  ],
  "Interval": 30000000000,
  "Timeout": 10000000000,
  "StartPeriod": 30000000000,
  "Retries": 3
}
```

Replace `PORT` with:
- `3000` for frontend
- `3003` for backend  
- `4003` for RAG API

### Update Configuration for Rollbacks:

```json
{
  "Parallelism": 1,
  "Delay": 10000000000,
  "FailureAction": "rollback",
  "Order": "start-first"
}
```

This ensures automatic rollback if health checks fail during deployment.
