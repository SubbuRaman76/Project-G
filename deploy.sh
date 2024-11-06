#!/bin/bash

# Variables
DOCKER_USER="subburaman76"
DEV_REPO="${DOCKER_USER}/project-dev"
PROD_REPO="${DOCKER_USER}/project-prod"

# Determine the current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Set the repository based on the branch
if [ "$BRANCH" == "dev" ]; then
  IMAGE="${DEV_REPO}:latest"
elif [ "$BRANCH" == "master" ]; then
  IMAGE="${PROD_REPO}:latest"
else
  echo "Deployment only configured for 'dev' or 'master' branches."
  exit 1
fi

# Deploy using docker-compose with the specified image
echo "Deploying ${IMAGE} to the server..."

# Update the docker-compose.yml file to use the correct image
cat <<EOF > docker-compose.yml
version: '3'
services:
  app:
    image: ${IMAGE}
    ports:
      - "80:80"
    restart: always
EOF

# Run docker-compose to deploy
docker-compose up -d
