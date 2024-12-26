# qBittorrent-nordvpn

A secure and efficient Docker setup that runs qBittorrent through NordVPN, ensuring all traffic is properly routed through the VPN. Built with security and ease of use in mind.

## Quick Start

### Option 1: Using Pre-built Image with Docker Compose (Recommended)

1. Create a `docker-compose.yml`:

```yaml
version: "3.8"

services:
  qbittorrent-vpn:
    image: ghcr.io/cubancodepath/qbittorrent-nordvpn:latest
    container_name: qbittorrent-vpn
    environment:
      - NORDVPN_TOKEN=your_token_here
      - NORDVPN_COUNTRY=spain
      - WEBUI_PORT=8080
      - TZ=Europe/Madrid
    cap_add:
      - NET_ADMIN
      - SYS_MODULE
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
      - net.ipv6.conf.all.disable_ipv6=1
    devices:
      - /dev/net/tun:/dev/net/tun
    ports:
      - "8080:8080"
      - 6181:6181
      - 6181:6181/udp
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    restart: unless-stopped
```

2. Create a `.env` file:

```env
NORDVPN_TOKEN=your_token_here
NORDVPN_COUNTRY=spain
WEBUI_PORT=8080
TZ=Europe/Madrid
```

3. Start the container:

```bash
docker-compose up -d
```

### Option 2: Using Pre-built Image with Docker Run

```bash
docker run -d \
  --name=qbittorrent-vpn \
  --cap-add=NET_ADMIN \
  --cap-add=SYS_MODULE \
  --device=/dev/net/tun \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv6.conf.all.disable_ipv6=1" \
  -p 8080:8080 \
  -p 6181:6181 \
  -p 6181:6181/udp \
  -v $(pwd)/config:/config \
  -v $(pwd)/downloads:/downloads \
  -e NORDVPN_TOKEN=your_token_here \
  -e NORDVPN_COUNTRY=spain \
  -e WEBUI_PORT=8080 \
  -e TZ=Europe/Madrid \
  --restart unless-stopped \
  ghcr.io/cubancodepath/qbittorrent-nordvpn:latest
```

## Features

🔒 Secure VPN integration with NordLynx
🔄 Automatic reconnection
🎯 Country selection support
🖥️ Web UI access
🔍 Health monitoring
👤 Non-root execution
🌐 Local network access preserved

## Configuration

### Environment Variables

| Variable          | Description                   | Default       |
| ----------------- | ----------------------------- | ------------- |
| `NORDVPN_TOKEN`   | Your NordVPN token (required) | none          |
| `NORDVPN_COUNTRY` | Country for VPN connection    | spain         |
| `WEBUI_PORT`      | Port for qBittorrent Web UI   | 8080          |
| `TZ`              | Container timezone            | Europe/Madrid |

### Volumes

The container uses two main volumes:

- `/config`: Contains qBittorrent configuration files
- `/downloads`: Directory for downloaded files

## Building from Source

If you prefer to build the image yourself:

1. Clone the repository:

```bash
git clone https://github.com/cubancodepath/qbittorrent-nordvpn.git
cd qbittorrent-nordvpn
```

2. Build and start the container:

```bash
docker-compose up -d --build
```

## Usage

### Accessing the Web UI

Once the container is running, access the qBittorrent Web UI at:

```
http://localhost:8080
```

Default login credentials:

- Username: `admin`
- Password: `adminadmin`

### Checking VPN Status

You can check if the VPN is connected by looking at the container logs:

```bash
docker-compose logs qbittorrent-vpn
```

## Security Considerations

- The container runs qBittorrent as a non-root user
- All traffic is routed through NordVPN
- Fail-safe: If VPN connection drops, internet access is blocked
- Container uses capabilities only as needed
- Images are automatically built and signed using GitHub Actions

## Troubleshooting

### Common Issues

1. **VPN Won't Connect**

   - Verify your NordVPN token is correct
   - Check container logs for connection errors
   - Ensure required capabilities are granted

2. **WebUI Not Accessible**

   - Verify the port mapping is correct
   - Check if the container is healthy
   - Look for any binding errors in the logs

3. **Downloads Not Starting**
   - Verify VPN connection status
   - Check if ports are properly forwarded
   - Ensure proper permissions on download directory

For more detailed troubleshooting, check the container logs:

```bash
docker-compose logs -f qbittorrent-vpn
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
