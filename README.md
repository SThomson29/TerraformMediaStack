# Media Server Infrastructure

A Terraform configuration for deploying a complete media server stack using Docker containers. This setup includes media management, download automation, reverse proxy, and DNS services.

## Architecture Overview

This infrastructure deploys the following services:

- **SWAG** - Nginx reverse proxy with SSL/TLS certificates via Let's Encrypt
- **Plex** - Media server for streaming movies and TV shows
- **Sonarr** - TV show management and automation
- **Radarr** - Movie management and automation
- **Lidarr** - Music management and automation
- **Prowlarr** - Indexer management for *arr applications
- **SABnzbd** - Usenet downloader
- **Gravity** - DNS and DHCP server

## Prerequisites

- Docker and Docker Compose installed on the target host
- Terraform >= 1.0 installed
- A domain name for SSL certificate generation
- Plex claim token for initial setup

## Directory Structure

The configuration expects the following directory structure on your host:

```
/path/to/your/base/directory/
├── Infra/
│   ├── Swag/config/
│   ├── Plex/config/
│   ├── Prowlarr/config/
│   ├── Radarr/config/
│   ├── Sonarr/config/
│   ├── Sabnzbd/config/
│   ├── Gravity/config/
│   └── Lidarr/config/
└── Media/
    └── Downloads/
        ├── TV/
        └── Movies/
```

**Note**: You'll need to update the volume mount paths in the Terraform configuration to match your preferred directory structure.

## Customizing File Paths

### Changing Base Directory

The Terraform configuration uses hardcoded paths for all volume mounts. To use your preferred directory structure:

1. **Find and Replace**: Update all volume mount paths in your Terraform files
2. **Example**: To change the base directory to `/opt/mediaserver/`:

```bash
# Using sed to replace all occurrences (adjust the paths as needed)
sed -i 's|/old/path/|/opt/mediaserver/|g' *.tf
```

### Common Directory Layouts

Choose a directory structure that fits your system:

**Option 1: Single User Home Directory**
```
/home/username/mediaserver/
├── config/
│   ├── swag/
│   ├── plex/
│   └── ...
└── data/
    └── downloads/
```

**Option 2: System-wide Installation**
```
/opt/mediaserver/
├── config/
└── data/
```

**Option 3: Docker-specific Location**
```
/var/lib/docker/volumes/mediaserver/
├── config/
└── data/
```

### Volume Mount Patterns

You'll need to update the volume mount patterns throughout the configuration:

- **Configuration directories**: Service-specific config directories
- **Media downloads**: Shared downloads directory for automation tools
- **TV shows**: Organized TV show storage for Plex
- **Movies**: Organized movie storage for Plex

## Configuration

### Required Variables

Create a `terraform.tfvars` file with the following variables:

```hcl
my_domain = "yourdomain.com"
plex_claim = "claim-xxxxxxxxxxxxxxxxxxxx"
```

### Variable Descriptions

- `my_domain`: Your domain name for SSL certificate generation and reverse proxy
- `plex_claim`: Plex claim token obtained from https://plex.tv/claim

## Network Configuration

The stack uses two network modes:

- **Custom Bridge Network** (`network_stack`): Used by most services for internal communication
- **Host Network**: Used by Plex and Gravity for direct host network access

## Port Mappings

- **80/443**: SWAG (HTTP/HTTPS)
- **32400**: Plex (accessible via host network)
- **53**: Gravity DNS (accessible via host network)

All other services are accessible through the SWAG reverse proxy.

## Deployment

1. Clone this repository
2. **Customize directory paths** (see [Customizing File Paths](#customizing-file-paths) section above)
3. Create the required directory structure on your host:
   ```bash
   # Replace /your/chosen/path with your preferred location
   BASE_PATH="/your/chosen/path"
   
   # Create configuration directories
   mkdir -p $BASE_PATH/Infra/{Swag,Plex,Prowlarr,Radarr,Sonarr,Sabnzbd,Gravity,Lidarr}/config
   
   # Create media directories
   mkdir -p $BASE_PATH/Media/Downloads/{TV,Movies}
   
   # Set appropriate permissions
   sudo chown -R 1000:1000 $BASE_PATH
   ```
4. Set up your `terraform.tfvars` file
5. Initialize and apply Terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Service Access

After deployment, services will be available at, just remember you will need DNS for this to work and will either need to configure gravity following these docs. 

https://gravity.beryju.io/docs/

Or replace the gravity container with another DHCP/DNS server. 

- **SWAG**: https://yourdomain.com
- **Plex**: http://host-ip:32400/web or https://plex.yourdomain.com
- **Sonarr**: https://sonarr.yourdomain.com
- **Radarr**: https://radarr.yourdomain.com
- **Lidarr**: https://lidarr.yourdomain.com
- **Prowlarr**: https://prowlarr.yourdomain.com
- **SABnzbd**: https://sabnzbd.yourdomain.com

**Permissions**: All containers run with configurable PUID/PGID values (default 1000:1000). Ensure your host directories have appropriate permissions for the specified UID/GID.

## Volume Mounts

### Configuration Volumes
Each service has its configuration directory mounted to persist settings and databases.

### Media Volumes
- Downloads are shared between download clients and media managers
- Plex has direct access to organized TV and movie directories

## SWAG Reverse Proxy Configuration

SWAG (Secure Web Application Gateway) acts as the reverse proxy for all services, providing SSL termination and subdomain routing.

https://docs.linuxserver.io/general/swag/ - Details can be found here. 

### SSL/TLS Certificates

SWAG automatically obtains and renews SSL certificates using Let's Encrypt with DNS validation via Cloudflare. Wildcard certificates are configured for subdomain access

## Logging

Gravity container includes log rotation configuration:
- Maximum log size: 10MB
- Maximum log files: 3

## Troubleshooting

### Common Issues

### Useful Commands

```bash
# Check container status
docker ps

# View container logs
docker logs <container_name>

# Access container shell
docker exec -it <container_name> /bin/bash

# Restart specific service
terraform apply -target=docker_container.<service_name>
```

## Security Considerations

- All services are behind the SWAG reverse proxy with SSL termination
- Fail2ban is disabled in SWAG (can be enabled by removing `DISABLE_F2B=true`)
- Do not allow any services to access your containers from the public internet without additional authentication, or unless you know what you are doing. 
- Regularly update container images for security patches

## Backup Strategy

Recommended backup locations:
- All service configuration directories contain critical application data
- Media files should be backed up based on your retention policy
- Consider automating backups of configuration directories

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the configuration
5. Submit a pull request

## License

This configuration is provided as-is for educational and personal use.
