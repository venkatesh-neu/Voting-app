#!/bin/bash
set -e

IMAGE=$1
TAG=$2
MANIFEST_FILE="voting-app.yaml"  # adjust if manifest path is different

echo "Updating $MANIFEST_FILE with image: $IMAGE:$TAG"

# Make sure the sed regex matches YAML "image:" lines
sed -i "s#image: .*#image: $IMAGE:$TAG#g" $MANIFEST_FILE

# Configure Git
git config user.email "build-bot@yourorg.com"
git config user.name "Build Bot"

# Stage and commit changes
git add $MANIFEST_FILE
git commit -m "Update image tag to $IMAGE:$TAG" || echo "No changes to commit"

# Push back to main branch (make sure pipeline has write access to repo)
git push origin main