#!/bin/bash
set -e

IMAGE=$1
TAG=$2
MANIFEST_FILE="voting-app.yaml"   # 👈 change if your deployment is elsewhere

echo "Updating $MANIFEST_FILE with $IMAGE:$TAG"

sed -i "s|image: $IMAGE:.*|image: $IMAGE:$TAG|" $MANIFEST_FILE

git config user.email "venkatesh.kalluri@neudesic.com"
git config user.name "venkatesh kalluri"
git add $MANIFEST_FILE
git commit -m "Update image tag to $IMAGE:$TAG"
git push origin main