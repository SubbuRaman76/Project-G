#!/bin/bash

# Variables
DOCKER_USER="subburaman76"
DEV_REPO="${DOCKER_USER}/project-dev"
PROD_REPO="${DOCKER_USER}/project-prod"

# Determine the current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Build the Docker image
docker build -t project-image:latest .

# Push the image based on the branch
if [ "$BRANCH" == "dev" ]; then
  echo "Pushing to the public dev repository on Docker Hub..."
  docker tag project-image:latest ${DEV_REPO}:latest
  docker push ${DEV_REPO}:latest
elif [ "$BRANCH" == "master" ]; then
  echo "Pushing to the private prod repository on Docker Hub..."
  docker tag project-image:latest ${PROD_REPO}:latest
  docker push ${PROD_REPO}:latest
else
  echo "Not on 'dev' or 'master' branch. No deployment configured for this branch."
fi
