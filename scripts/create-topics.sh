#!/bin/bash

# This script creates the necessary Kafka topics

# Get the Kafka pod
KAFKA_POD=$(kubectl get pods -l app=kafka -o jsonpath='{.items[0].metadata.name}')

# Create the messages topic
echo "Creating app-messages topic..."
kubectl exec $KAFKA_POD -- kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 4 \
  --topic app-messages

# Create the tasks topic
echo "Creating app-tasks topic..."
kubectl exec $KAFKA_POD -- kafka-topics.sh --create \
  --bootstrap-server localhost:9092 \
  --replication-factor 1 \
  --partitions 4 \
  --topic app-tasks

echo "Topics created successfully."

# List the topics
echo "Kafka topics:"
kubectl exec $KAFKA_POD -- kafka-topics.sh --list --bootstrap-server localhost:9092