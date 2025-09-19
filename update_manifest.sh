#!/bin/bash
set -e

IMAGE_NAME=$1
TAG=$2
BRANCH=$3
MANIFEST_FILE="manifests/voting-app.yaml"   # 👈 FIXED path

echo "Branch: $BRANCH"
echo "Image: $IMAGE_NAME:$TAG"
echo "Manifest file: $MANIFEST_FILE"

# ✅ Only allow main branch to update GitOps manifest
if [ "$BRANCH" != "main" ]; then
  echo "Skipping manifest update: branch is '$BRANCH' (only main can update)."
  exit 0
fi

# 🔹 Update image in manifest (preserve indentation)
sed -i "s|\(image:\s*\).*|\1$IMAGE_NAME:$TAG|g" $MANIFEST_FILE

echo "Updated $MANIFEST_FILE with image $IMAGE_NAME:$TAG"

# 🔹 Git config
git config user.email "venkatesh.kalluri@neudesic.com"
git config user.name "venkatesh kalluri"

# 🔹 Commit & push changes
git add $MANIFEST_FILE
if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "Update image to $IMAGE_NAME:$TAG"
  git push origin main
  echo "Changes pushed to main branch."
fi