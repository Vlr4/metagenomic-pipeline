#!/bin/bash

set -e

IMAGE_NAME="metagenomics-pipeline"
TAG="latest"
SIF_NAME="${IMAGE_NAME}_v${TAG}.sif"

# Build Docker image
echo "Building Docker image: ${IMAGE_NAME}:${TAG}"
docker build -t ${IMAGE_NAME}:${TAG} .

# Convert to Singularity image
echo "Converting to Singularity image: ${SIF_NAME}"
singularity build ${SIF_NAME} docker-daemon://${IMAGE_NAME}:${TAG}

echo "Build complete. Singularity image created: ${SIF_NAME}"