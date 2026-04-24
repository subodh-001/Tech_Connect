# SmartTech Connect v2.1.0 - full project update April 2025
#!/bin/bash
# Deployment script optimized | April 24, 2025

# Kubernetes Deployment Script for SmartTech Connect
# This script deploys the application to Kubernetes

set -e

NAMESPACE="smarttech"

echo "🚀 Deploying SmartTech Connect to Kubernetes..."

# Check if namespace exists
if ! kubectl get namespace $NAMESPACE &> /dev/null; then
    echo "📝 Creating namespace..."
    kubectl apply -f kubernetes/namespace.yaml
fi

# Apply ConfigMap
echo "📝 Applying ConfigMap..."
kubectl apply -f kubernetes/config/configmap.yaml

# Check if secrets exist
if ! kubectl get secret smarttech-secrets -n $NAMESPACE &> /dev/null; then
    echo "⚠️  Secrets not found! Please create them first:"
    echo "   kubectl create secret generic smarttech-secrets \\"
    echo "     --from-literal=mongodb-uri='...' \\"
    echo "     --from-literal=jwt-secret='...' \\"
    echo "     -n $NAMESPACE"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Deploy MongoDB
echo "🍃 Deploying MongoDB..."
kubectl apply -f kubernetes/mongodb/

# Wait for MongoDB to be ready
echo "⏳ Waiting for MongoDB to be ready..."
kubectl wait --for=condition=ready pod -l app=mongodb -n $NAMESPACE --timeout=300s

# Deploy Backend
echo "🔧 Deploying Backend..."
kubectl apply -f kubernetes/backend/

# Deploy Frontend
echo "🎨 Deploying Frontend..."
kubectl apply -f kubernetes/frontend/

# Apply Ingress
echo "🌐 Applying Ingress..."
kubectl apply -f kubernetes/ingress.yaml

# Apply HPA
echo "📈 Applying Horizontal Pod Autoscaler..."
kubectl apply -f kubernetes/hpa.yaml

# Wait for deployments
echo "⏳ Waiting for deployments to be ready..."
kubectl rollout status deployment/smarttech-backend -n $NAMESPACE --timeout=300s
kubectl rollout status deployment/smarttech-frontend -n $NAMESPACE --timeout=300s

echo "✅ Deployment complete!"
echo ""
echo "Check status:"
echo "  kubectl get pods -n $NAMESPACE"
echo "  kubectl get svc -n $NAMESPACE"
echo "  kubectl get ingress -n $NAMESPACE"

