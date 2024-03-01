#!/bin/zsh

# Install minikube
brew install minikube
brew install kubectl
brew install helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Start minikube
minikube stop
minikube delete
minikube start

# Install Redis using Helm
helm install bullets-db bitnami/redis --set auth.password='1234qwerASDF'

# Use the minikube registry
eval $(minikube docker-env)

# Build the docker image for the app
cd ..
docker build -t bullets-app:latest .
cd -

# Create a kubernetes deployment and a service for the app
kubectl apply -f bullets-app.yaml

# Loop wait until the app is running
while [ $(kubectl get pods | grep bullets-app | grep Running | wc -l | tr -d ' ') -eq 0 ]; do
  echo "Waiting for the app to be running"
  sleep 5
done

# forward the port to the app
mkdir ./log
kubectl port-forward service/bullets-app-service 8080:8080 > ./log/port-forward.log 2>&1 &


# Run the client in a docker container
cd ../test/e2e
docker build -t bullets-client:latest .
cd -



docker rm -f client
docker run -d --env "LB_ADDRESS=host.docker.internal" --env "CONCURRENCY=100" --name client bullets-client

docker logs -f client
