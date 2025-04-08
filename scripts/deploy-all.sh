#!/bin/bash

# This script deploys the entire application stack

# Install KEDA if not already installed
if ! kubectl get namespace keda &> /dev/null; then
  echo "Installing KEDA..."
  helm repo add kedacore https://kedacore.github.io/charts
  helm repo update
  helm install keda kedacore/keda --namespace keda --create-namespace

  # Wait for KEDA to be ready
  echo "Waiting for KEDA to be ready..."
  kubectl wait --namespace keda \
    --for=condition=available \
    --timeout=300s \
    deployment/keda-operator
else
  echo "KEDA is already installed."
fi

# Deploy Kafka and Zookeeper
echo "Deploying Kafka and Zookeeper..."
kubectl apply -f k8s/kafka/

# Wait for Kafka to be ready
echo "Waiting for Kafka to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/kafka

# Initialize monitoring
echo "Initializing monitoring components..."
./scripts/initialize-monitoring.sh

# Deploy the application
echo "Deploying the application..."
kubectl apply -f k8s/app/

# Wait for the application to be ready
echo "Waiting for the application to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/keda-demo

# Create Kafka topics
echo "Creating Kafka topics..."
./scripts/create-topics.sh

echo "Deployment completed successfully!"
echo ""
echo "To access the application:"
echo "kubectl port-forward svc/keda-demo 8080:80"
echo ""
echo "To access Grafana:"
echo "kubectl port-forward svc/grafana-service -n monitoring 3000:3000"