# Deployment Guide

## Alur Deployment

1. Push kode ke GitHub → GitHub Actions otomatis build & push Docker image ke GitHub Container Registry
2. Di VPS → Jalankan script deployment untuk pull & run image

## Setup Awal di VPS

### Port Configuration
Aplikasi ini dikonfigurasi untuk berjalan di **port 5558** baik di dalam container maupun di host VPS.

### 1. Install Docker di VPS
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

### 2. Setup GitHub Personal Access Token
- Buka GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
- Generate new token dengan permissions: `read:packages`, `write:packages`, `delete:packages`

## Cara Deployment

### Automatic (Recommended)
Setiap kali Anda push ke branch `main`, GitHub Actions akan otomatis:
- Build Docker image
- Push ke GitHub Container Registry (`ghcr.io/azhariazna/coba_coba`)

### Manual Deployment di VPS

#### Option 1: Menggunakan script deployment
```bash
# Copy script ke VPS
scp deploy.sh user@your-vps-ip:~/

# SSH ke VPS dan jalankan
ssh user@your-vps-ip
./deploy.sh [tag]
# atau untuk latest:
./deploy.sh
```

#### Option 2: Manual commands
```bash
# Login ke GitHub Container Registry
echo "YOUR_GITHUB_TOKEN" | docker login ghcr.io -u YOUR_USERNAME --password-stdin

# Pull image
docker pull ghcr.io/azhariazna/coba_coba:latest

# Stop & remove container lama
docker stop coba_coba && docker rm coba_coba

# Run container baru
docker run -d -p 5558:5558 --name coba_coba --restart unless-stopped ghcr.io/azhariazna/coba_coba:latest
```

## Versi Image

Image tags yang tersedia:
- `latest` - Versi terbaru dari branch main
- `main-{commit-sha}` - Spesifik commit SHA
- Branch names untuk branch lain

## Monitoring

### Cek status container
```bash
docker ps
docker logs coba_coba
```

### Restart container
```bash
docker restart coba_coba
```

### Update ke versi terbaru
```bash
./deploy.sh
```

## Troubleshooting

### Image tidak ditemukan
- Pastikan GitHub Actions sudah selesai running
- Cek tag image yang benar

### Permission denied
- Pastikan sudah login ke GitHub Container Registry
- Periksa Personal Access Token permissions

### Port conflict
- Ubah port mapping di command docker run (misal: `-p 8080:5558`)
