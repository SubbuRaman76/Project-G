#!/bin/bash

# Variables
DOCKER_USER="subburaman76"
DEV_REPO="${DOCKER_USER}/project-dev"
PROD_REPO="${DOCKER_USER}/project-prod"
IMAGE=""

# Determine the current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Set the repository based on the branch
if [ "$BRANCH" == "dev" ]; then
  IMAGE="${DEV_REPO}:latest"
elif [ "$BRANCH" == "main" ]; then
  IMAGE="${PROD_REPO}:latest"
else
  echo "Deployment only configured for 'dev' or 'main' branches."
  exit 1
fi

echo "Deploying image ${IMAGE} to the server..."

# Docker login to Docker Hub (ensure you have Docker credentials set up in Jenkins or manually login if running locally)
echo "Logging in to Docker Hub..."
docker login -u $DOCKER_USER -p $DOCKER_PASSWORD

# Build and tag the Docker image
echo "Building Docker image..."
docker build -t $IMAGE .

# Push the image to Docker Hub
echo "Pushing Docker image ${IMAGE} to Docker Hub..."
docker push $IMAGE

# Navigate to the directory with the docker-compose.yml file (adjust if needed)
cd /path/to/your/docker-compose/directory

# Make sure to stop and remove the old container if it exists
echo "Stopping and removing any existing containers..."
docker-compose down

# Start the container with docker-compose
echo "Starting the new container with docker-compose..."
docker-compose up -d

# Optionally, you can clean up unused Docker images
echo "Cleaning up unused Docker images..."
docker system prune -f
