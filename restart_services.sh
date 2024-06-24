#!/bin/bash

docker_login() {
  echo "Logging in to Docker..."
  docker login
}

cleanup_docker() {
  echo "Stopping all running Docker containers..."
  docker stop $(docker ps -q) || echo "No running Docker containers to stop."

  echo "Removing all Docker containers..."
  docker rm $(docker ps -aq) || echo "No Docker containers to remove."

  echo "Removing all Docker images..."
  docker rmi $(docker images -q) || echo "No Docker images to remove."

  echo "Removing all Docker volumes..."
  docker volume rm $(docker volume ls -q) || echo "No Docker volumes to remove."

  echo "Pruning all unused Docker data..."
  docker system prune -a --volumes -f

  echo "Pruning all build caches..."
  docker builder prune -af
}

stop_kubernetes() {
  echo "Stopping Kubernetes cluster..."
  kind delete cluster --name kind
}

build_and_push_images() {
  echo "Building and pushing Docker images..."
  docker build -t vendettistudios/bis-service:latest BIS/nest-bis/bis-service/
  docker push vendettistudios/bis-service:latest

  docker build -t vendettistudios/crm-service:latest CRM/nest-crm/crm-service/
  docker push vendettistudios/crm-service:latest

  docker build -t vendettistudios/erp-service:latest ERP/nest-erp/erp-service/
  docker push vendettistudios/erp-service:latest

  docker build -t vendettistudios/ims-service:latest WMS/IMS/nest-ims/ims-service/
  docker push vendettistudios/ims-service:latest

  docker build -t vendettistudios/oms-service:latest WMS/OMS/nest-oms/oms-service/
  docker push vendettistudios/oms-service:latest

  docker build -t vendettistudios/tms-service:latest TMS/nest-tms/tms-service/
  docker push vendettistudios/tms-service:latest

  docker build -t vendettistudios/wo-service:latest WMS/WO/nest-wo/wo-service/
  docker push vendettistudios/wo-service:latest
}

start_kubernetes() {
  echo "Starting Kubernetes cluster..."
  kind create cluster --name kind

  echo "Using the correct Kubernetes context..."
  kubectl config use-context kind-kind

  echo "Deploying Prometheus..."
  kubectl apply -f Monitoring/Prometheus/prometheus-deployment.yaml
  kubectl apply -f Monitoring/Prometheus/prometheus-rbac.yaml
  kubectl apply -f Monitoring/Prometheus/prometheus-service.yaml

  echo "Deploying services..."
  kubectl apply -f k8s/bis-service/bis-service-deployment.yaml
  kubectl apply -f k8s/bis-service/bis-service-service.yaml
  kubectl apply -f k8s/crm-service/crm-service-deployment.yaml
  kubectl apply -f k8s/crm-service/crm-service-service.yaml
  kubectl apply -f k8s/erp-service/erp-service-deployment.yaml
  kubectl apply -f k8s/erp-service/erp-service-service.yaml
  kubectl apply -f k8s/ims-service/ims-service-deployment.yaml
  kubectl apply -f k8s/ims-service/ims-service-service.yaml
  kubectl apply -f k8s/oms-service/oms-service-deployment.yaml
  kubectl apply -f k8s/oms-service/oms-service-service.yaml
  kubectl apply -f k8s/tms-service/tms-service-deployment.yaml
  kubectl apply -f k8s/tms-service/tms-service-service.yaml
  kubectl apply -f k8s/wo-service/wo-service-deployment.yaml
  kubectl apply -f k8s/wo-service/wo-service-service.yaml

  echo "Port forwarding services..."
  kubectl port-forward service/prometheus 9090:9090 -n default &

  services=("bis-service" "crm-service" "erp-service" "ims-service" "oms-service" "tms-service" "wo-service")
  for service in "${services[@]}"; do
    port=$(kubectl get svc $service -o jsonpath='{.spec.ports[0].port}')
    if [ -z "$port" ]; then
      echo "Error: Service $service does not have a service port defined."
    else
      kubectl port-forward service/$service $port:3000 -n default &
    fi
  done

  echo "Creating Kubernetes Dashboard..."
  kubectl create namespace kubernetes-dashboard
  kubectl create serviceaccount dashboard -n kubernetes-dashboard
  kubectl create clusterrolebinding dashboard-admin -n kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

  echo "Use this token to login to the Kubernetes Dashboard:"
  kubectl get secret $(kubectl get serviceaccount dashboard -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 --decode

  echo "Starting the Kubernetes proxy..."
  pkill -f "kubectl proxy" || true
  kubectl proxy &
}

check_pod_status() {
  echo "Checking pod status..."
  kubectl get pods -n default
  echo "If any pod is in 'Pending' status, check the events:"
  kubectl get events --sort-by=.metadata.creationTimestamp -n default

  echo "Checking node status..."
  kubectl get nodes
  kubectl describe nodes
}

cleanup_ports() {
  echo "Checking for existing processes on port 3000..."
  lsof -i :3000
  if [ $? -eq 0 ]; then
    echo "Killing existing processes on port 3000..."
    kill -9 $(lsof -t -i :3000)
  else
    echo "No existing processes on port 3000."
  fi
}

main() {
  docker_login
  cleanup_ports
  cleanup_docker
  stop_kubernetes
  build_and_push_images
  start_kubernetes
  check_pod_status
}

main
