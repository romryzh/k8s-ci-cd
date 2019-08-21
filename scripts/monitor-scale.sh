#!/bin/bash

#Retrieve the latest git commit hash
BUILD_TAG=`git rev-parse --short HEAD`

#Build the docker image
docker build -t 127.0.0.1:30400/monitor-scale:$BUILD_TAG -f applications/monitor-scale/Dockerfile applications/monitor-scale

#Push the images
docker push 127.0.0.1:30400/monitor-scale:$BUILD_TAG

# Setup RBAC auth for monitor-scale
kubectl apply -f manifests/monitor-scale-serviceaccount.yaml

# Create the deployment and service for the monitor-scale node server
sed 's#127.0.0.1:30400/monitor-scale:$BUILD_TAG#127.0.0.1:30400/monitor-scale:'$BUILD_TAG'#' applications/monitor-scale/k8s/deployment.yaml | kubectl apply -f -
