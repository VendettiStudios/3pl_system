#!/bin/bash

# Build and push Docker images
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

# Log in to Docker (if not already logged in)
docker login

# Use the correct Kubernetes context
kubectl config use-context kind-kind

# Deploy Prometheus
kubectl apply -f Monitoring/Prometheus/prometheus-deployment.yaml
kubectl apply -f Monitoring/Prometheus/prometheus-rbac.yaml
kubectl apply -f Monitoring/Prometheus/prometheus-service.yaml

# Deploy services
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

# Verify deployments and services
kubectl get services -n default
kubectl get deployments -n default
kubectl get pods -n default

# Port forward Prometheus
kubectl port-forward service/prometheus 9090:9090 -n default &

# Port forward all services
kubectl port-forward service/bis-service 3008:3000 -n default &
kubectl port-forward service/crm-service 3002:3000 -n default &
kubectl port-forward service/erp-service 3003:3000 -n default &
kubectl port-forward service/ims-service 3005:3000 -n default &
kubectl port-forward service/oms-service 3006:3000 -n default &
kubectl port-forward service/tms-service 3004:3000 -n default &
kubectl port-forward service/wo-service 3007:3000 -n default &

# Create Kubernetes Dashboard
kubectl create serviceaccount dashboard -n kubernetes-dashboard
kubectl create clusterrolebinding dashboard-admin -n kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml

# Retrieve the dashboard token
echo "Use this token to login to the Kubernetes Dashboard:"
kubectl get secret $(kubectl get serviceaccount dashboard -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 --decode

# Start the Kubernetes proxy
kubectl proxy &

# Edit the Kubernetes Dashboard service to be accessible externally
kubectl edit service/kubernetes-dashboard -n kubernetes-dashboard

# Start Docker Compose services
docker-compose up -d