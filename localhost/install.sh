#!/bin/zsh

# Install minikube
brew install minikube
brew install kubectl
brew install helm
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

# Start minikube
open --background -a Docker
minikube stop && minikube delete && minikube start 

# Install Redis using Helm
helm install bullets-db bitnami/redis --set auth.password='1234qwerASDF'

# This is used to replace the LB_ADDRESS_PLACEHOLDER in the nginx.conf.tpl file

# Build the docker image for the client
cd ../test/e2e
sed "s|LB_ADDRESS_PLACEHOLDER|host.docker.internal|g" nginx.conf.tpl > nginx.conf
docker build -t bullets-client:latest .
cd -

# Build the docker image for the app
eval $(minikube docker-env)
cd ..
docker build -t bullets-app:latest .
cd -

# Create a kubernetes deployment and a service for the app
kubectl apply -f bullets-app.yaml

# forward the port to the app
kubectl port-forward service/bullets-app-service 8080:8080 &

# Run the client with host networking

docker run -d -v $(pwd)/log/nginx:/var/log/nginx -v $(pwd)/log/client:/var/log/client --name client bullets-client

tail -f log/client/bullets.log