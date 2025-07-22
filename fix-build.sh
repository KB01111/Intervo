#!/bin/bash

# Fix build issues by cleaning cache and rebuilding properly

echo "🧹 Cleaning build cache and fixing build issues..."

# Clean Next.js cache
echo "Cleaning Next.js cache..."
rm -rf packages/intervo-frontend/.next
rm -rf packages/intervo-frontend/node_modules/.cache

# Clean widget build
echo "Cleaning widget build..."
rm -rf packages/intervo-widget/dist
rm -rf packages/intervo-widget/node_modules/.cache

# Clean root node_modules cache
echo "Cleaning root cache..."
rm -rf node_modules/.cache

# Reinstall dependencies
echo "Reinstalling dependencies..."
npm install --legacy-peer-deps

# Build widget first
echo "Building widget..."
cd packages/intervo-widget
npm install --legacy-peer-deps
npm run build:umd
npm run build:es
cd ../..

# Build frontend
echo "Building frontend..."
cd packages/intervo-frontend
npm install --legacy-peer-deps
npm run build
cd ../..

echo "✅ Build fix complete!"
