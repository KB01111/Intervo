#!/bin/bash

# Comprehensive build script for Intervo App
# This script builds all components in the correct order

echo "🚀 Building Intervo App - All Components"
echo "========================================"

# Function to check if command succeeded
check_success() {
    if [ $? -ne 0 ]; then
        echo "❌ Error: $1 failed"
        exit 1
    fi
    echo "✅ $1 completed successfully"
}

# Step 1: Install root dependencies
echo ""
echo "📦 Step 1: Installing root dependencies..."
npm install --legacy-peer-deps
check_success "Root dependency installation"

# Step 2: Build widget first (required by frontend)
echo ""
echo "🔧 Step 2: Building Intervo Widget..."
cd packages/intervo-widget
npm install --legacy-peer-deps
check_success "Widget dependency installation"

npm run build:umd
check_success "Widget UMD build"

npm run build:es
check_success "Widget ES build"

echo "📁 Widget built files are in packages/intervo-widget/dist/"

# Step 3: Build frontend
echo ""
echo "🏗️ Step 3: Building Frontend..."
cd ../intervo-frontend
npm install --legacy-peer-deps
check_success "Frontend dependency installation"

npm run build
check_success "Frontend build"

echo "📁 Frontend built files are in packages/intervo-frontend/.next/"

# Step 4: Install backend dependencies
echo ""
echo "📦 Step 4: Installing Backend dependencies..."
cd ../intervo-backend
npm install --legacy-peer-deps
check_success "Backend dependency installation"

# Step 5: Install RAG API dependencies
echo ""
echo "🐍 Step 5: Installing RAG API dependencies..."
cd rag_py
if command -v python3 &> /dev/null; then
    echo "Installing Python dependencies..."
    pip3 install -r requirements.txt
    check_success "RAG API dependency installation"
else
    echo "⚠️ Python3 not found, skipping RAG API dependency installation"
    echo "   Dependencies will be installed in Docker container"
fi

# Return to root
cd ../../..

echo ""
echo "🎉 Build Complete!"
echo "=================="
echo "✅ Widget: Built and ready"
echo "✅ Frontend: Built and ready"
echo "✅ Backend: Dependencies installed"
echo "✅ RAG API: Dependencies ready"
echo ""
echo "🚀 Ready for deployment!"
echo ""
echo "Next steps:"
echo "1. Run: docker-compose up --build"
echo "2. Or for production: docker-compose -f docker-compose.prod.yml up --build"
