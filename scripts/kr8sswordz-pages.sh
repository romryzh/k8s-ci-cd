
#!/bin/bash

#Retrieve the latest git commit hash
BUILD_TAG=`git rev-parse --short HEAD`

#Build the docker image
docker build -t 127.0.0.1:30400/kr8sswordz:$BUILD_TAG -f applications/kr8sswordz-pages/Dockerfile applications/kr8sswordz-pages

echo "5 second sleep to make sure the registry is ready"
sleep 5;

#Push the images
docker push 127.0.0.1:30400/kr8sswordz:$BUILD_TAG

# Create the deployment and service for the front end aka kr8sswordz
sed 's#127.0.0.1:30400/kr8sswordz:$BUILD_TAG#127.0.0.1:30400/kr8sswordz:'$BUILD_TAG'#' applications/kr8sswordz-pages/k8s/deployment.yaml | kubectl apply -f -
