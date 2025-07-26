#!/bin/bash

# Build script for Intervo Widget
# This script builds the widget separately to avoid Docker build issues

echo "🔧 Building Intervo Widget..."

# Navigate to widget directory
cd packages/intervo-widget

# Install dependencies
echo "📦 Installing dependencies..."
npm install

# Build the widget
echo "🏗️ Building widget..."
npm run build:umd
npm run build:es

echo "✅ Widget build complete!"
echo "📁 Built files are in packages/intervo-widget/dist/"
