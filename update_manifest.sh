#!/bin/bash
set -e

IMAGE_NAME=$1   # e.g. argocdregistry.azurecr.io/voting-app
TAG=$2          # e.g. build ID
BRANCH=$3       # e.g. main or dev
MANIFEST_FILE="manifests/voting-app.yaml"  # adjust if your manifest is elsewhere

echo "Branch: $BRANCH"
echo "Image: $IMAGE_NAME:$TAG"
echo "Manifest file: $MANIFEST_FILE"

# ✅ Only allow main branch to update GitOps manifest
if [ "$BRANCH" != "main" ]; then
  echo "Skipping manifest update: branch is '$BRANCH' (only main can update)."
  exit 0
fi

# 🔹 Update image in manifest
sed -i "s|image: .*|image: $IMAGE_NAME:$TAG|g" $MANIFEST_FILE

echo "Updated $MANIFEST_FILE with image $IMAGE_NAME:$TAG"

# 🔹 Git config
git config user.email "build-bot@yourorg.com"
git config user.name "Build Bot"

# 🔹 Commit & push changes
git add $MANIFEST_FILE
if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "Update image to $IMAGE_NAME:$TAG"
  git push origin main
  echo "Changes pushed to main branch."