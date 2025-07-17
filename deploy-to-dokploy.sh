#!/bin/bash

# Intervo Open Source Dokploy Deployment Script
# This script helps prepare and deploy Intervo Open Source to Dokploy
# Based on: https://docs.intervo.ai/open-source/setup

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists docker; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! command_exists curl; then
        print_error "curl is not installed. Please install curl first."
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Setup environment files
setup_environment() {
    print_status "Setting up environment files..."

    # Backend environment
    if [ ! -f ".env.production" ]; then
        if [ -f ".env.production.example" ]; then
            cp .env.production.example .env.production
            print_warning "Created .env.production from template. Please edit it with your actual values."
        else
            print_error ".env.production.example not found. Please create environment file manually."
            exit 1
        fi
    else
        print_success "Backend environment file already exists"
    fi

    # Frontend environment
    if [ ! -f "Intervo/packages/intervo-frontend/.env.production" ]; then
        print_warning "Frontend .env.production not found. Creating from template..."
        cat > Intervo/packages/intervo-frontend/.env.production << EOF
NODE_ENV=production
NEXT_PUBLIC_API_URL_PRODUCTION=https://api.yourdomain.com
EOF
    fi

    # Widget environment
    if [ ! -f "Intervo/packages/intervo-widget/.env.production" ]; then
        print_warning "Widget .env.production not found. Creating from template..."
        cat > Intervo/packages/intervo-widget/.env.production << EOF
VITE_API_URL_PRODUCTION=https://api.yourdomain.com
EOF
    fi

    print_warning "You MUST update the following before deployment:"
    echo "  - Replace 'yourdomain.com' with your actual domain in ALL environment files"
    echo "  - Add your API keys (OpenAI, Twilio, etc.) in .env.production"
    echo "  - Set secure JWT and session secrets (minimum 32 characters)"
    echo "  - Configure database credentials if needed"
    echo ""
    read -p "Press Enter after you've updated all environment files..."
}

# Validate environment file
validate_environment() {
    print_status "Validating environment configuration..."
    
    if [ ! -f ".env.production" ]; then
        print_error ".env.production file not found"
        exit 1
    fi
    
    # Check for placeholder values
    if grep -q "yourdomain.com" .env.production; then
        print_error "Please replace 'yourdomain.com' with your actual domain in .env.production"
        exit 1
    fi
    
    # Check for required variables (based on open source documentation)
    required_vars=("SESSION_SECRET" "NEXTAUTH_SECRET" "ENCRYPTION_KEY" "MONGO_URI")
    for var in "${required_vars[@]}"; do
        if ! grep -q "^${var}=" .env.production || grep -q "^${var}=$" .env.production; then
            print_error "Required variable ${var} is not set in .env.production"
            exit 1
        fi
    done
    
    print_success "Environment validation passed"
}

# Build Docker images locally (optional)
build_images() {
    if [ "$1" = "--build" ]; then
        print_status "Building Docker images locally..."
        
        # Build frontend
        print_status "Building frontend image..."
        docker build -f Dockerfile.frontend.prod -t intervo-frontend:latest .
        
        # Build backend
        print_status "Building backend image..."
        docker build -f Intervo/packages/intervo-backend/Dockerfile.prod -t intervo-backend:latest Intervo/packages/intervo-backend/
        
        # Build RAG API
        print_status "Building RAG API image..."
        docker build -f Intervo/packages/intervo-backend/rag_py/Dockerfile.prod -t intervo-rag:latest Intervo/packages/intervo-backend/rag_py/
        
        print_success "All images built successfully"
    fi
}

# Test Docker Compose configuration
test_compose() {
    print_status "Testing Docker Compose configuration..."
    
    if [ ! -f "dokploy-docker-compose.yml" ]; then
        print_error "dokploy-docker-compose.yml not found"
        exit 1
    fi
    
    # Validate compose file
    docker-compose -f dokploy-docker-compose.yml config > /dev/null
    print_success "Docker Compose configuration is valid"
}

# Display deployment instructions
show_deployment_instructions() {
    print_success "Pre-deployment checks completed!"
    echo ""
    print_status "Next steps for Dokploy deployment:"
    echo ""
    echo "1. DNS Configuration:"
    echo "   Configure these A records pointing to your Dokploy server IP:"
    echo "   - app.yourdomain.com → YOUR_SERVER_IP"
    echo "   - api.yourdomain.com → YOUR_SERVER_IP"
    echo "   - rag.yourdomain.com → YOUR_SERVER_IP"
    echo ""
    echo "2. Dokploy Deployment:"
    echo "   - Login to your Dokploy dashboard"
    echo "   - Create new Docker Compose project"
    echo "   - Upload dokploy-docker-compose.yml"
    echo "   - Set environment variables from .env.production"
    echo "   - Deploy the application"
    echo ""
    echo "3. SSL Certificates:"
    echo "   - Certificates will be automatically issued via Let's Encrypt"
    echo "   - Wait 5-10 minutes after DNS propagation"
    echo ""
    echo "4. Verify Deployment:"
    echo "   - Check https://app.yourdomain.com"
    echo "   - Test API at https://api.yourdomain.com/health"
    echo "   - Test RAG API at https://rag.yourdomain.com/health"
    echo ""
    print_warning "Remember to replace 'yourdomain.com' with your actual domain!"
}

# Main execution
main() {
    echo "=================================================="
    echo "    Intervo Dokploy Deployment Preparation"
    echo "=================================================="
    echo ""
    
    check_prerequisites
    setup_environment
    validate_environment
    build_images "$1"
    test_compose
    show_deployment_instructions
    
    print_success "Deployment preparation completed successfully!"
}

# Run main function with all arguments
main "$@"
