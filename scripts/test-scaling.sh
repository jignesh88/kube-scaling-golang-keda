#!/bin/bash

# This script tests the scaling behavior by generating load

# Set default values
MESSAGES=${1:-500}
TASKS=${2:-200}
COMPLEXITY=${3:-5}

# Get the service IP
SERVICE_IP=$(kubectl get svc keda-demo -o jsonpath='{.spec.clusterIP}')

echo "Current pods:"
kubectl get pods -l app=keda-demo

echo "Starting scaling test..."
echo "- Sending $MESSAGES messages to Kafka"
echo "- Sending $TASKS tasks with complexity $COMPLEXITY"

# Send messages
curl -X POST "http://$SERVICE_IP/messages?count=$MESSAGES" > /dev/null
echo "Messages sent."

# Send tasks
curl -X POST "http://$SERVICE_IP/tasks?count=$TASKS&complexity=$COMPLEXITY" > /dev/null
echo "Tasks sent."

# Monitor pods
echo "Monitoring pods for scaling..."
kubectl get pods -l app=keda-demo -w