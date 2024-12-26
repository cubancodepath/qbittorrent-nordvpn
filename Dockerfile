# Use Ubuntu as base image
FROM ubuntu:24.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install NordVPN and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    curl\
    apt-transport-https \
    ca-certificates && \
    wget -qO /etc/apt/trusted.gpg.d/nordvpn_public.asc https://repo.nordvpn.com/gpg/nordvpn_public.asc && \
    echo "deb https://repo.nordvpn.com/deb/nordvpn/debian stable main" > /etc/apt/sources.list.d/nordvpn.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends nordvpn && \
    # Install qBittorrent
    apt-get install -y qbittorrent-nox && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create non-root user for qBittorrent
RUN useradd -m -s /bin/bash qbittorrent

# Create necessary directories
RUN mkdir -p /config /downloads && \
    chown -R qbittorrent:qbittorrent /config /downloads

# Copy and setup startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports for Web UI and BitTorrent
EXPOSE 8080 6181 6181/udp

# Setup volumes
VOLUME ["/config", "/downloads"]

# Add heal