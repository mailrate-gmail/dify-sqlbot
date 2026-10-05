#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME="${1:-}"
VERSION="${2:-1.0.0}"

if [[ -z "$IMAGE_NAME" ]]; then
  echo "Usage: $0 <registry/repository/sqlbot-dify-mcp> [version]"
  echo "Example: $0 docker.io/yourname/sqlbot-dify-mcp 1.0.0"
  exit 1
fi

cd "$(dirname "$0")/sqlbot-dify-mcp"

docker build -t sqlbot-dify-mcp:"$VERSION" .
docker tag sqlbot-dify-mcp:"$VERSION" "$IMAGE_NAME":"$VERSION"
docker tag sqlbot-dify-mcp:"$VERSION" "$IMAGE_NAME":latest
docker push "$IMAGE_NAME":"$VERSION"
docker push "$IMAGE_NAME":latest

echo "Pushed:"
echo "  $IMAGE_NAME:$VERSION"
echo "  $IMAGE_NAME:latest"
