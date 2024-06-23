## RD

# Warehouse 3PL Management System

## Description
The Warehouse 3PL Management System is a comprehensive solution for managing third-party logistics operations. It includes modules for inventory management, order management, warehouse management, transportation management, customer management, enterprise resource planning, business intelligence and analytics, and integration middleware.

## Table of Contents
- [Description](#description)
- [Installation](#installation)
- [Usage](#usage)
- [Microservices](#microservices)
  - [Inventory Management Service](#inventory-management-service)
  - [Order Management Service](#order-management-service)
  - [Warehouse Management Service](#warehouse-management-service)
  - [Transportation Management Service](#transportation-management-service)
  - [Customer Management Service](#customer-management-service)
  - [Enterprise Resource Planning Service](#enterprise-resource-planning-service)
  - [Business Intelligence and Analytics Service](#business-intelligence-and-analytics-service)
  - [Integration Middleware](#integration-middleware)
- [Contributing](#contributing)
- [License](#license)
- [Contact Information](#contact-information)

## Installation
1. Clone the repository: `git clone https://github.com/your-repo/warehouse-3pl-management-system.git`
2. Navigate to the project directory: `cd warehouse-3pl-management-system`
3. Follow the installation steps for each microservice.

## Usage
Start each microservice as described in their respective README files. Ensure all services are running and accessible.

## Microservices

### Inventory Management Service
See [Inventory Management Service README](./inventory-management-service/README.md).

### Order Management Service
See [Order Management Service README](./order-management-service/README.md).

### Warehouse Management Service
See [Warehouse Management Service README](./warehouse-management-service/README.md).

### Transportation Management Service
See [Transportation Management Service README](./transportation-management-service/README.md).

### Customer Management Service
See [Customer Management Service README](./customer-management-service/README.md).

### Enterprise Resource Planning Service
See [Enterprise Resource Planning Service README](./enterprise-resource-planning-service/README.md).

### Business Intelligence and Analytics Service
See [Business Intelligence and Analytics Service README](./business-intelligence-and-analytics-service/README.md).

### Integration Middleware
See [Integration Middleware README](./integration-middleware/README.md).

## License
This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for details.

## Contact Information
For questions or support, please contact [your-email@example.com](mailto:your-email@example.com).


## How to Start Services Locally
#!/bin/bash

# Build and push Docker images
docker build -t <UserName>/bis-service:latest BIS/nest-bis/bis-service/
docker push <UserName>/bis-service:latest

docker build -t <UserName>/crm-service:latest CRM/nest-crm/crm-service/
docker push <UserName>/crm-service:latest

docker build -t <UserName>/erp-service:latest ERP/nest-erp/erp-service/
docker push <UserName>/erp-service:latest

docker build -t <UserName>/ims-service:latest WMS/IMS/nest-ims/ims-service/
docker push <UserName>/ims-service:latest

docker build -t <UserName>/oms-service:latest WMS/OMS/nest-oms/oms-service/
docker push <UserName>/oms-service:latest

docker build -t <UserName>/tms-service:latest TMS/nest-tms/tms-service/
docker push <UserName>/tms-service:latest

docker build -t <UserName>/wo-service:latest WMS/WO/nest-wo/wo-service/
docker push <UserName>/wo-service:latest

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














## Commands
docker build -t (username)/bis-service:latest BIS/nest-bis/bis-service/
docker push (username)/bis-service:latest          

docker build -t (username)/crm-service:latest CRM/nest-crm/crm-service/
docker push (username)/crm-service:latest          

docker build -t (username)/erp-service:latest ERP/nest-erp/erp-service/
docker push (username)/erp-service:latest

docker build -t (username)/ims-service:latest WMS/IMS/nest-ims/ims-service/
docker push (username)/ims-service:latest

docker build -t (username)/oms-service:latest WMS/OMS/nest-oms/oms-service/
docker push (username)/oms-service:latest

docker build -t (username)/tms-service:latest TMS/nest-tms/tms-service/
docker push (username)/tms-service:latest

docker build -t (username)/wo-service:latest WMS/WO/nest-wo/wo-service/
docker push (username)/wo-service:latest


docker login
kubectl config use-context kind-kind           

kubectl apply -f Monitoring/Prometheus/prometheus-deployment.yaml
kubectl apply -f Monitoring/Prometheus/prometheus-rbac.yaml
kubectl apply -f Monitoring/Prometheus/prometheus-service.yaml

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

kubectl get services -n default                                  
kubectl get deployments -n default       
kubectl get pods -n default    

kubectl port-forward service/prometheus 9090:9090 -n default

docker ps   


(
  kubectl port-forward service/bis-service 3001:3001 -n default
kubectl port-forward service/crm-service 3002:3002 -n default
kubectl port-forward service/erp-service 3003:3003 -n default
kubectl port-forward service/ims-service 3005:3005 -n default
kubectl port-forward service/oms-service 3006:3006 -n default
kubectl port-forward service/tms-service 3004:3004 -n default
kubectl port-forward service/wo-service 3007:3007 -n default

)


kubectl create serviceaccount dashboard -n kubernetes-dashboard kubectl create clusterrolebinding dashboard-admin -n kubernetes-dashboard --clusterrole=cluster-admin --serviceaccount=kubernetes-dashboard:dashboard
kubectl get secret $(kubectl get serviceaccount dashboard -n kubernetes-dashboard -o jsonpath="{.secrets[0].name}") -n kubernetes-dashboard -o jsonpath="{.data.token}" | base64 --decode
kubectl proxy 
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.2.0/aio/deploy/recommended.yaml
kubectl edit service/kubernetes-dashboard -n kubernetes-dashboard



 docker-compose up -d     
docker-compose down 
## Trouble shooting commands

kubectl rollout restart deployment prometheus-deployment -n default
ubectl delete deployments --all -n default                                 
kubectl delete services --all -n default   
ex. (Port forward for oms-service) kubectl port-forward service/oms-service 3006:3006 -n default
ex. (restart for wo service) kubectl rollout restart deployment/wo-service -n default    
ex. (Logs for wo service) kubectl logs -f deployment/wo-service -n default 
ex. (Logs of oms service) kubectl logs oms-service-cf9b6c7d-pkqn9 -n default 
ex. (Set image deployment oms) kubectl set image deployment/oms-service oms-service=<username>/oms-service:latest -n default
ex. (exec oms) kubectl exec -it oms-service-cf9b6c7d-pkqn9 -n default -- nslookup oms-service.default.svc.cluster.local
ex. (delete bis pod) kubectl delete pod bis-service-844cf64c67-fq7k6 -n default
ex.(describe bis) kubectl describe service bis-service -n default     
ex. (get bis deployment) kubectl get deployment bis-service -o yaml -n default    
kubectl config get-contexts     
kubectl cluster-info     
kind delete cluster  

sudo lsof -i :<port>
 ps -p <id> -o comm=         