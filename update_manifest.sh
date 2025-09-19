#!/bin/bash
set -e

IMAGE=$1
TAG=$2
MANIFEST_FILE="voting-app.yaml"

echo "Updating $MANIFEST_FILE with image: $IMAGE:$TAG"

sed -i "s#image: .*#image: $IMAGE:$TAG#g" $MANIFEST_FILE

git config user.email "venkatesh.kalluri@neudesic.com"
git config user.name "venkatesh kalluri"

git checkout main   # 👈 make sure we’re on main
git pull origin main

git add $MANIFEST_FILE
git commit -m "Update image tag to $IMAGE:$TAG" || echo "No changes to commit"

git push origin main