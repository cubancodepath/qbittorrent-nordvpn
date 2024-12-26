# qBittorrent with NordVPN Docker

This repository contains a Docker setup for running qBittorrent through NordVPN, ensuring all torrent traffic is routed through a secure VPN connection.

## Features

- Runs qBittorrent with NordVPN protection
- Uses NordLynx for better performance
- Automatic VPN connection on startup
- Health checks for both VPN and qBittorrent
- Non-root user for improved security
- Web UI access
- Configurable ports and settings

## Prerequisites

- Docker and Docker Compose installed
- Valid NordVPN account and token
- Git (for cloning the repository)

## Configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
NORDVPN_TOKEN=your_token_here
NORDVPN_COUNTRY=spain
WEBUI_PORT=8080
TZ=Europe/Madrid
```

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

## Installation

### Using Docker Compose (Recommended)

1. Clone the repository:

```bash
git clone https://github.com/yourusername/qbittorrent-nordvpn-docker.git
cd qbittorrent-nordvpn-docker
```

2. Create your `.env` file:

```bash
cp .env.example .env
# Edit .env with your settings
```

3. Create the required directories:

```bash
mkdir -p config downloads
```

4. Build and start the container:

```bash
docker-compose up -d --build
```

5. To stop the container:

```bash
docker-compose down
```

### Using Docker

1. Clone the repository:

```bash
git clone https://github.com/yourusername/qbittorrent-nordvpn-docker.git
cd qbittorrent-nordvpn-docker
```

2. Build the image:

```bash
docker build -t qbittorrent-nordvpn .
```

3. Create the required directories:

```bash
mkdir -p config downloads
```

4. Run the container:

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
  qbittorrent-nordvpn
```

5. To stop the container:

```bash
docker stop qbittorrent-vpn
```

6. To remove the container:

```bash
docker rm qbittorrent-vpn
```

### Running from Docker Hub

You can also pull and run the image directly from Docker Hub:

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
  yourusername/qbittorrent-nordvpn:latest
```

## Usage

### Accessing the Web UI

Once the container is running, you can access the qBittorrent Web UI at:

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

### Container Health

The container includes health checks that verify both VPN connectivity and qBittorrent availability. You can monitor the health status with:

```bash
docker ps
```

## Network Configuration

The container is configured with the following network settings:

- WebUI Port: 8080 (configurable)
- Bittorrent Port: 6181 (TCP/UDP)
- Local network access is preserved through NordVPN whitelist
- IPv6 is disabled by default

### Whitelisted Networks

The following local networks are whitelisted by default:

- 172.16.0.0/12
- 192.168.0.0/16
- 10.0.0.0/8

## Security Considerations

- The container runs qBittorrent as a non-root user
- All traffic is routed through NordVPN
- Fail-safe: If VPN connection drops, internet access is blocked
- Container uses capabilities only as needed
- Sensitive configuration is handled through environment variables

## Building from Source

To build the image locally:

```bash
docker-compose build
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

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

### Getting Help

If you encounter any issues:

1. Check the container logs
2. Look for similar issues in the GitHub issues
3. Create a new issue with detailed information about your problem

## Acknowledgments

- NordVPN for their Linux implementation
- qBittorrent team for their excellent client
- Docker community for container best practices
