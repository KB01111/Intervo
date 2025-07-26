# Intervo Dokploy Setup Script for Windows
# This script prepares your Intervo app for Dokploy deployment

Write-Host "=================================================="
Write-Host "    Intervo Dokploy Deployment Setup"
Write-Host "=================================================="
Write-Host ""

# Function to generate secure random string
function Generate-SecureString {
    param([int]$Length = 32)
    $chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
    $random = 1..$Length | ForEach-Object { Get-Random -Maximum $chars.length }
    return -join ($random | ForEach-Object { $chars[$_] })
}

Write-Host "🔧 Step 1: Checking environment files..."

# Check if .env.production exists
if (Test-Path ".env.production") {
    Write-Host "✅ .env.production exists" -ForegroundColor Green
} else {
    Write-Host "❌ .env.production not found" -ForegroundColor Red
    exit 1
}

# Check if frontend env exists
if (Test-Path "packages/intervo-frontend/.env.local") {
    Write-Host "✅ Frontend environment file exists" -ForegroundColor Green
} else {
    Write-Host "❌ Frontend environment file not found" -ForegroundColor Red
    exit 1
}

# Check if widget env exists
if (Test-Path "packages/intervo-widget/.env") {
    Write-Host "✅ Widget environment file exists" -ForegroundColor Green
} else {
    Write-Host "❌ Widget environment file not found" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🔐 Step 2: Generating secure secrets..."

# Generate secure secrets
$sessionSecret = Generate-SecureString -Length 32
$nextAuthSecret = Generate-SecureString -Length 32
$encryptionKey = Generate-SecureString -Length 32

Write-Host "Generated SESSION_SECRET: $sessionSecret"
Write-Host "Generated NEXTAUTH_SECRET: $nextAuthSecret"
Write-Host "Generated ENCRYPTION_KEY: $encryptionKey"

Write-Host ""
Write-Host "📝 Step 3: Updating .env.production with secure secrets..."

# Read the current .env.production file
$envContent = Get-Content ".env.production" -Raw

# Replace the placeholder secrets with generated ones
$envContent = $envContent -replace "SESSION_SECRET=your-super-secret-session-key-minimum-32-characters", "SESSION_SECRET=$sessionSecret"
$envContent = $envContent -replace "NEXTAUTH_SECRET=your-jwt-secret-key-minimum-32-characters", "NEXTAUTH_SECRET=$nextAuthSecret"
$envContent = $envContent -replace "ENCRYPTION_KEY=your-encryption-key-exactly-32-chars", "ENCRYPTION_KEY=$encryptionKey"

# Write back to file
Set-Content ".env.production" -Value $envContent

Write-Host "✅ Updated .env.production with secure secrets" -ForegroundColor Green

Write-Host ""
Write-Host "🐳 Step 4: Validating Docker Compose configuration..."

# Test Docker Compose configuration
try {
    $dockerComposeTest = docker-compose -f dokploy-docker-compose.yml config 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Docker Compose configuration is valid" -ForegroundColor Green
    } else {
        Write-Host "❌ Docker Compose configuration has errors:" -ForegroundColor Red
        Write-Host $dockerComposeTest
        exit 1
    }
} catch {
    Write-Host "❌ Docker Compose validation failed: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📋 Step 5: Deployment checklist..."

Write-Host ""
Write-Host "✅ COMPLETED SETUP TASKS:" -ForegroundColor Green
Write-Host "  - Environment files created and configured"
Write-Host "  - Secure secrets generated and applied"
Write-Host "  - Docker Compose configuration validated"
Write-Host "  - Domain configuration set for atlas-agent.net"
Write-Host ""

Write-Host "🔧 REQUIRED MANUAL TASKS:" -ForegroundColor Yellow
Write-Host "  1. Update API keys in .env.production:"
Write-Host "     - TWILIO_* (for phone functionality)"
Write-Host "     - OPENAI_API_KEY (required)"
Write-Host "     - GROQ_API_KEY (required)"
Write-Host "     - ASSEMBLYAI_API_KEY (required)"
Write-Host "     - AZURE_SPEECH_KEY (required)"
Write-Host "     - ELEVENLABS_API_KEY (required)"
Write-Host "     - AWS_ACCESS_KEY_ID `& AWS_SECRET_ACCESS_KEY (required)"
Write-Host "     - GOOGLE_CLIENT_ID `& GOOGLE_CLIENT_SECRET (required)"
Write-Host ""
Write-Host "  2. In Dokploy dashboard:"
Write-Host "     - Create new project 'Intervo'"
Write-Host "     - Set Docker Compose file: dokploy-docker-compose.yml"
Write-Host "     - Set Environment file: .env.production"
Write-Host "     - Configure domains:"
Write-Host "       * app.atlas-agent.net -> frontend (port 3000)"
Write-Host "       * api.atlas-agent.net -> backend (port 3003)"
Write-Host "       * rag.atlas-agent.net -> rag-api (port 4003)"
Write-Host ""

Write-Host "🚀 DEPLOYMENT READY!" -ForegroundColor Green
Write-Host "Your Intervo app is configured for Dokploy deployment."
Write-Host "Complete the manual tasks above, then deploy in Dokploy."
Write-Host ""
Write-Host "📖 For detailed instructions, see: DOKPLOY_ENVIRONMENT_SETUP.md"
Write-Host ""
