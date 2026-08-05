#!/bin/bash

# Script deployment untuk VPS
# Penggunaan: ./deploy.sh [image-tag]

set -e

# Default image tag
IMAGE_TAG=${1:-latest}
IMAGE_NAME="ghcr.io/azhariazna/coba_coba"
CONTAINER_NAME="coba_coba"

echo "🚀 Mulai deployment..."
echo "📦 Image: $IMAGE_NAME:$IMAGE_TAG"

# Login ke GitHub Container Registry
echo "🔐 Login ke GitHub Container Registry..."
echo "Masukkan GitHub Personal Access Token:"
read -s GITHUB_TOKEN
echo $GITHUB_TOKEN | docker login ghcr.io -u azhariazna --password-stdin

# Pull latest image
echo "⬇️  Pull image dari registry..."
docker pull $IMAGE_NAME:$IMAGE_TAG

# Stop dan remove container lama jika ada
echo "🛑 Stop container lama (jika ada)..."
if [ "$(docker ps -q -f name=$CONTAINER_NAME)" ]; then
    docker stop $CONTAINER_NAME
fi

if [ "$(docker ps -aq -f name=$CONTAINER_NAME)" ]; then
    docker rm $CONTAINER_NAME
fi

# Jalankan container baru
echo "🏃 Jalankan container baru..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 5558:5558 \
  --restart unless-stopped \
  $IMAGE_NAME:$IMAGE_TAG

# Cleanup unused images
echo "🧹 Cleanup unused images..."
docker image prune -f

echo "✅ Deployment selesai!"
echo "🌐 Aplikasi berjalan di http://localhost:5558"
