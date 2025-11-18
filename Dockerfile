# Multi-stage build for Flutter web app
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

# Copy pubspec files first for better caching
COPY pubspec.yaml pubspec.lock ./

# Get dependencies
RUN flutter pub get

# Copy source code and assets
COPY lib/ ./lib/
COPY assets/ ./assets/
COPY web/ ./web/
COPY analysis_options.yaml ./

# Build for web in release mode
RUN flutter build web --release

# Production stage with nginx
FROM nginx:alpine

# Copy built web files
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]

