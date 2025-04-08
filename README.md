# Kubernetes Scaling Demo with Golang, KEDA, Kafka, Prometheus and Grafana

This repository demonstrates a complete solution for event-driven autoscaling in Kubernetes using KEDA (Kubernetes Event-driven Autoscaling), Kafka, Prometheus, and Grafana.

## Architecture

The application consists of the following components:

1. **Golang API Service**:
   - Exposes HTTP endpoints for health checks, info, sending messages and tasks
   - Produces messages and tasks to Kafka topics
   - Consumes messages and tasks from Kafka topics
   - Exposes Prometheus metrics for monitoring and scaling

2. **Kafka**:
   - Message broker for asynchronous processing
   - Two topics: `app-messages` and `app-tasks`

3. **KEDA**:
   - Monitors Kafka queue depth and Prometheus metrics
   - Scales the application based on workload

4. **Prometheus**:
   - Collects and stores metrics from the application
   - Provides query capabilities for KEDA scalers

5. **Grafana**:
   - Visualizes metrics from Prometheus
   - Custom dashboards for monitoring application performance and scaling

## Key Features

1. **Horizontal Pod Autoscaling with KEDA**:
   - Scale based on Kafka queue depth
   - Scale based on custom Prometheus metrics
   - Multiple scaling triggers with different thresholds

2. **Vertical Pod Autoscaling with Kubernetes VPA**:
   - Automatically adjust CPU and memory resources
   - Optimize resource allocation for individual pods

3. **Metrics Collection**:
   - HTTP request metrics (count, duration)
   - CPU and memory utilization
   - Kafka message and task production rates
   - Queue depths
   - Processing task counts

4. **Visualization with Grafana**:
   - Real-time dashboards
   - Metrics correlation
   - Scaling visualization

## Getting Started

See the [Deployment Guide](docs/deployment-guide.md) for detailed instructions on how to deploy this application to your Kubernetes cluster.

## Testing Scaling Behavior

The repository includes scripts for testing the scaling behavior, located in the `scripts` directory. These can be used to generate load and observe how KEDA scales the application in response.

## Directory Structure

```
├── main.go                 # Main application
├── Dockerfile              # For containerization
├── go.mod                  # Go module definition
├── k8s/                    # Kubernetes manifests
│   ├── app/                # Application manifests
│   ├── kafka/              # Kafka and Zookeeper manifests
│   └── monitoring/         # Prometheus and Grafana manifests
├── scripts/                # Helper scripts for deployment and testing
└── docs/                   # Documentation
```

## License

MIT