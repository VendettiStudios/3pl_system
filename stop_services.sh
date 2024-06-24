#!/bin/bash

set -e

# Docker login
echo "Logging in to Docker..."
docker login || echo "Docker login failed. Please ensure your credentials are correct."

# Stop all running Docker containers
echo "Stopping all running Docker containers..."
if [ "$(docker ps -q)" ]; then
  docker stop $(docker ps -q)
else
  echo "No running Docker containers to stop."
fi

# Remove all Docker containers
echo "Removing all Docker containers..."
if [ "$(docker ps -aq)" ]; then
  docker rm $(docker ps -aq)
else
  echo "No Docker containers to remove."
fi

# Remove all Docker images
echo "Removing all Docker images..."
if [ "$(docker images -q)" ]; then
  docker rmi $(docker images -q)
else
  echo "No Docker images to remove."
fi

# Remove all Docker volumes
echo "Removing all Docker volumes..."
if [ "$(docker volume ls -q)" ]; then
  docker volume rm $(docker volume ls -q)
else
  echo "No Docker volumes to remove."
fi

# Remove all Docker build cache
echo "Removing all Docker build cache..."
docker builder prune -af || echo "No Docker build cache to remove."

# Prune all unused Docker data
echo "Pruning all unused Docker data..."
docker system prune -af --volumes || echo "No Docker data to prune."

# Stop Kubernetes cluster if running
echo "Stopping Kubernetes cluster..."
kind delete cluster || echo "No Kubernetes cluster to delete."
