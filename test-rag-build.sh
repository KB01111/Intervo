#!/bin/bash

# Test script to build and verify the RAG API Docker container

echo "🔧 Testing RAG API Docker build..."

# Build the RAG API container
echo "Building RAG API container..."
cd packages/intervo-backend/rag_py
docker build -f Dockerfile.prod -t test-rag-api .

if [ $? -eq 0 ]; then
    echo "✅ Docker build successful!"
    
    # Test the container startup
    echo "🚀 Testing container startup..."
    docker run --rm -d --name test-rag-api -p 4004:4003 test-rag-api
    
    # Wait a few seconds for startup
    sleep 10
    
    # Test health endpoint
    echo "🏥 Testing health endpoint..."
    curl -f http://localhost:4004/health
    
    if [ $? -eq 0 ]; then
        echo "✅ RAG API is running successfully!"
    else
        echo "❌ Health check failed"
        docker logs test-rag-api
    fi
    
    # Clean up
    docker stop test-rag-api
    docker rmi test-rag-api
    
else
    echo "❌ Docker build failed!"
    exit 1
fi

echo "🎉 RAG API test completed!"
