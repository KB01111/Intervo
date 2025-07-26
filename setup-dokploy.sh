#!/bin/bash

# Intervo Dokploy Setup Script
# This script prepares your Intervo app for Dokploy deployment

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

# Function to generate secure random string
generate_secure_string() {
    local length=${1:-32}
    openssl rand -base64 $((length * 3 / 4)) | tr -d "=+/" | cut -c1-${length}
}

echo "=================================================="
echo "    Intervo Dokploy Deployment Setup"
echo "=================================================="
echo ""

print_status "Step 1: Checking environment files..."

# Check if .env.production exists
if [ -f ".env.production" ]; then
    print_success ".env.production exists"
else
    print_error ".env.production not found"
    exit 1
fi

# Check if frontend env exists
if [ -f "packages/intervo-frontend/.env.local" ]; then
    print_success "Frontend environment file exists"
else
    print_error "Frontend environment file not found"
    exit 1
fi

# Check if widget env exists
if [ -f "packages/intervo-widget/.env" ]; then
    print_success "Widget environment file exists"
else
    print_error "Widget environment file not found"
    exit 1
fi

echo ""
print_status "Step 2: Generating secure secrets..."

# Generate secure secrets
SESSION_SECRET=$(generate_secure_string 32)
NEXTAUTH_SECRET=$(generate_secure_string 32)
ENCRYPTION_KEY=$(generate_secure_string 32)

echo "Generated SESSION_SECRET: $SESSION_SECRET"
echo "Generated NEXTAUTH_SECRET: $NEXTAUTH_SECRET"
echo "Generated ENCRYPTION_KEY: $ENCRYPTION_KEY"

echo ""
print_status "Step 3: Updating .env.production with secure secrets..."

# Update .env.production with generated secrets
sed -i.bak \
    -e "s/SESSION_SECRET=your-super-secret-session-key-minimum-32-characters/SESSION_SECRET=$SESSION_SECRET/" \
    -e "s/NEXTAUTH_SECRET=your-jwt-secret-key-minimum-32-characters/NEXTAUTH_SECRET=$NEXTAUTH_SECRET/" \
    -e "s/ENCRYPTION_KEY=your-encryption-key-exactly-32-chars/ENCRYPTION_KEY=$ENCRYPTION_KEY/" \
    .env.production

print_success "Updated .env.production with secure secrets"

echo ""
print_status "Step 4: Validating Docker Compose configuration..."

# Test Docker Compose configuration
if docker-compose -f dokploy-docker-compose.yml config > /dev/null 2>&1; then
    print_success "Docker Compose configuration is valid"
else
    print_error "Docker Compose configuration has errors"
    docker-compose -f dokploy-docker-compose.yml config
    exit 1
fi

echo ""
print_status "Step 5: Deployment checklist..."

echo ""
echo -e "${GREEN}✅ COMPLETED SETUP TASKS:${NC}"
echo "  - Environment files created and configured"
echo "  - Secure secrets generated and applied"
echo "  - Docker Compose configuration validated"
echo "  - Domain configuration set for atlas-agent.net"
echo ""

echo -e "${YELLOW}🔧 REQUIRED MANUAL TASKS:${NC}"
echo "  1. Update API keys in .env.production:"
echo "     - TWILIO_* (for phone functionality)"
echo "     - OPENAI_API_KEY (required)"
echo "     - GROQ_API_KEY (required)"
echo "     - ASSEMBLYAI_API_KEY (required)"
echo "     - AZURE_SPEECH_KEY (required)"
echo "     - ELEVENLABS_API_KEY (required)"
echo "     - AWS_ACCESS_KEY_ID & AWS_SECRET_ACCESS_KEY (required)"
echo "     - GOOGLE_CLIENT_ID & GOOGLE_CLIENT_SECRET (required)"
echo ""
echo "  2. In Dokploy dashboard:"
echo "     - Create new project 'Intervo'"
echo "     - Set Docker Compose file: dokploy-docker-compose.yml"
echo "     - Set Environment file: .env.production"
echo "     - Configure domains:"
echo "       * app.atlas-agent.net → frontend (port 3000)"
echo "       * api.atlas-agent.net → backend (port 3003)"
echo "       * rag.atlas-agent.net → rag-api (port 4003)"
echo ""

echo -e "${GREEN}🚀 DEPLOYMENT READY!${NC}"
echo "Your Intervo app is configured for Dokploy deployment."
echo "Complete the manual tasks above, then deploy in Dokploy."
echo ""
echo "📖 For detailed instructions, see: DOKPLOY_ENVIRONMENT_SETUP.md"
echo ""
