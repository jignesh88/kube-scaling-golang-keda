#!/bin/bash

# This script initializes the monitoring components

# Create monitoring namespace if it doesn't exist
if ! kubectl get namespace monitoring &> /dev/null; then
  echo "Creating monitoring namespace..."
  kubectl create namespace monitoring
else
  echo "Monitoring namespace already exists."
fi

# Apply Prometheus manifests
echo "Deploying Prometheus..."
kubectl apply -f k8s/monitoring/prometheus/

# Apply Grafana manifests
echo "Deploying Grafana..."
kubectl apply -f k8s/monitoring/grafana/

# Wait for Prometheus and Grafana to be ready
echo "Waiting for Prometheus to be ready..."
kubectl wait --namespace monitoring \
  --for=condition=available \
  --timeout=300s \
  deployment/prometheus

echo "Waiting for Grafana to be ready..."
kubectl wait --namespace monitoring \
  --for=condition=available \
  --timeout=300s \
  deployment/grafana

echo "Monitoring components deployed successfully."

# Port-forwarding instructions
echo ""
echo "To access Prometheus UI:"
echo "kubectl port-forward svc/prometheus-service -n monitoring 9090:9090"
echo ""
echo "To access Grafana:"
echo "kubectl port-forward svc/grafana-service -n monitoring 3000:3000"
echo "Default credentials: admin/admin"