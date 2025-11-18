# Docker Quick Reference

## Quick Start

```bash
# Build and run with Docker Compose (recommended)
docker-compose up --build

# Access the app at: http://localhost:8080
```

## Manual Docker Commands

```bash
# Build the image
docker build -t wordle-app .

# Run the container
docker run -d -p 8080:80 --name wordle wordle-app

# View logs
docker logs wordle

# Stop the container
docker stop wordle

# Remove the container
docker rm wordle

# Remove the image
docker rmi wordle-app
```

## Troubleshooting

### Port already in use
If port 8080 is already in use, change it in `docker-compose.yml`:
```yaml
ports:
  - "3000:80"  # Use port 3000 instead
```

### Build fails
Make sure you have:
- Docker installed and running
- Internet connection (to download Flutter base image)
- Sufficient disk space (~2GB for build)

### Container won't start
Check logs:
```bash
docker logs wordle
```

## How It Works

1. **Build Stage**: Uses Flutter SDK to compile the web app
2. **Production Stage**: Uses lightweight nginx to serve static files through server
3. **Result**: Small, fast container (~50MB) serving your app

## Customization

### Change Port
Edit `docker-compose.yml`:
```yaml
ports:
  - "YOUR_PORT:80"
```

### Change Container Name
Edit `docker-compose.yml`:
```yaml
container_name: your-name
```

#### 🔄 Delete & Rebuild Container

Sometimes you may want to completely remove your container and rebuild the app from scratch. Here’s how:

---

**With Docker Compose:**

```bash
# Stop and remove containers, networks, volumes, and images
docker-compose down --rmi all --volumes --remove-orphans

# Rebuild and start fresh
docker-compose up --build


