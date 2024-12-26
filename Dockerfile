# Use Ubuntu as base
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

# Create required directories
RUN mkdir -p /config /downloads

# Copy and setup startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports for WebUI and BitTorrent
EXPOSE 8080 6181 6181/udp

# Define volumes for configuration and downloads
VOLUME ["/config", "/downloads"]

# Add healthcheck for VPN and qBittorrent status
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD nordvpn status | grep -q "Status: Connected" && \
        curl -sf http://localhost:8080 || exit 1

# Set container startup command
ENTRYPOINT ["/start.sh"]