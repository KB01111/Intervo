# 🔧 RAG API Troubleshooting Guide

## ✅ Issues Fixed

### 1. **Missing Dependencies**
- **Added**: `ratelimit==2.2.1` to requirements.txt
- **Issue**: Crawler module was importing ratelimit but it wasn't in requirements

### 2. **Import Path Issues**
- **Created**: `start_api.py` with proper path setup and dependency checking
- **Updated**: Docker configuration to use the new startup script
- **Fixed**: Python path configuration for local module imports

### 3. **Error Handling**
- **Added**: Comprehensive dependency checking before startup
- **Added**: Detailed logging for troubleshooting
- **Added**: Graceful error handling with informative messages

## 🚀 Files Updated

### New Files:
- ✅ `packages/intervo-backend/rag_py/start_api.py` - Startup script with dependency checking
- ✅ Updated `packages/intervo-backend/rag_py/requirements.txt` - Added ratelimit dependency
- ✅ Updated `packages/intervo-backend/rag_py/Dockerfile` - Uses new startup script
- ✅ Updated `docker-compose.yml` - Uses new startup script

## 🔍 Common RAG API Issues & Solutions

### Issue 1: "ModuleNotFoundError: No module named 'ratelimit'"
- **Cause**: Missing ratelimit dependency
- **Solution**: ✅ Added to requirements.txt

### Issue 2: "ModuleNotFoundError: No module named 'storage'"
- **Cause**: Import path issues
- **Solution**: ✅ Fixed in start_api.py with proper path setup

### Issue 3: "ModuleNotFoundError: No module named 'rag_service'"
- **Cause**: Local module import issues
- **Solution**: ✅ Fixed with enhanced Python path configuration

### Issue 4: FastAPI/LangChain Import Errors
- **Cause**: Version conflicts or missing packages
- **Solution**: ✅ Added dependency checking in startup script

## 🧪 Testing the RAG API

### 1. **Check Container Logs**
```bash
docker-compose logs rag-api
```

### 2. **Expected Startup Messages**
```
🚀 Starting RAG API...
✅ FastAPI dependencies OK
✅ LangChain dependencies OK
✅ FAISS import OK
✅ AWS dependencies OK
✅ Ratelimit dependency OK
✅ All dependencies available
✅ Storage module OK
✅ Crawler module OK
✅ RAG service module OK
Starting FastAPI application...
```

### 3. **Test API Health**
```bash
curl http://localhost:4003/health
```

### 4. **Expected Response**
```json
{
  "status": "healthy",
  "service": "RAG API",
  "version": "1.0.0"
}
```

## 🔧 Manual Troubleshooting

### If RAG API Still Fails:

1. **Check Python Version**
   - Ensure using Python 3.11 (as specified in Dockerfile)

2. **Check Environment Variables**
   - Ensure AWS credentials are set (if using S3)
   - Check OpenAI API key (if using OpenAI embeddings)

3. **Check File Permissions**
   - Ensure all files are readable by the ragapi user

4. **Check Network Connectivity**
   - Ensure container can reach external APIs (OpenAI, AWS, etc.)

### Debug Commands:
```bash
# Enter the container
docker-compose exec rag-api bash

# Check Python path
python -c "import sys; print(sys.path)"

# Test imports manually
python -c "from storage import S3Storage; print('Storage OK')"
python -c "from crawler import WebCrawler; print('Crawler OK')"
python -c "from rag_service import RagTrainer; print('RAG Service OK')"
```

## 🎯 Next Steps

1. **Rebuild the RAG API container**:
   ```bash
   docker-compose down
   docker-compose build rag-api
   docker-compose up rag-api
   ```

2. **Monitor the logs** for the new startup messages

3. **Test the API endpoints** once it's running

4. **If issues persist**, check the specific error messages in the logs and refer to this guide

## 📋 Environment Variables for RAG API

Ensure these are set in your environment:

```env
# AWS (for S3 storage)
AWS_ACCESS_KEY_ID=your-aws-access-key
AWS_SECRET_ACCESS_KEY=your-aws-secret-key
AWS_REGION=us-east-1

# OpenAI (for embeddings)
OPENAI_API_KEY=sk-your-openai-api-key

# Optional: Groq API
GROQ_API_KEY=gsk_your-groq-api-key

# Optional: Voyage AI
VOYAGE_API_KEY=your-voyage-api-key
```
