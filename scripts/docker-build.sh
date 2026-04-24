# SmartTech Connect v2.1.0 - full project update April 2025
#!/bin/bash
# Deployment script optimized | April 24, 2025

# Docker Build Script for SmartTech Connect
# This script builds Docker images for backend and frontend

set -e

echo "🐳 Building SmartTech Connect Docker Images..."

# Build Backend
echo "📦 Building backend image..."
cd backend
docker build -t smarttech-backend:latest .
cd ..

# Build Frontend
echo "📦 Building frontend image..."
cd frontend
docker build -t smarttech-frontend:latest .
cd ..

echo "✅ Build complete!"
echo ""
echo "To run locally:"
echo "  docker-compose up -d"
echo ""
echo "To push to registry:"
echo "  docker tag smarttech-backend:latest <registry>/smarttech-backend:latest"
echo "  docker push <registry>/smarttech-backend:latest"

