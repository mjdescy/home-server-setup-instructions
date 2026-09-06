# Prod

## Details

| Hostname | Domain Name           | Description                                 | Operating System |
| -------- | --------------------- | ------------------------------------------- | ---------------- |
| prod     | prod.lan.19781013.syz | Production server hosting critical services | Debian 13        |

## Hardware Specifications

| Manufacturer | Model | Processor  | RAM  | System Disk  | Storage Disks | Network Interfaces                                |
| ------------ | ----- | ---------- | ---- | ------------ | ------------- | ------------------------------------------------- |
| BeeLink      | EQ14  | Intel N150 | 16GB | 1x 512GB SSD | 1 4TB SSD     | 2x Gigabit Ethernet; 1x WiFi 6 (currently unused) |

## Purpose

The production server is the main server that hosts all the critical services. It is configured to ensure high availability and stability. 

## Services

The following user-facing services are hosted on the production server and are run in containers using Podman and configured as quadlets:

- Web server/reverse proxy: Caddy
- Media server: Jellyfin
- Usenet downloader: Sabnzbd
- Movie manager: Radarr
- TV show manager: Sonarr
- Browser bookmark manager: Karakeep
- Paperless document manager: Paperless-ngx

The following services are hosted on the production server and are run natively and were installed via the Debian package manager:

- File sync: rsync
- File sharing: NFS
- Secure file transfer: OpenSSH

All ZFS datasets are shared via NFS only. This setup was performed using ZFS's built-in NFS sharing capabilities, which allows for efficient and secure file sharing across the network.

## Virtualization

Podman is used for containerization, allowing for easy deployment and management of services. All user-facing services are run in containers, while the host system is kept minimal and secure.

All Podman containers on this server are run as rootless containers, which means that they run as a non-root user, do not require root privileges to run. Rootless containers provide an additional layer of security, as it reduces the attack surface of the system and limits the potential damage that can be done by a compromised container. 

All Podman containers on this server are configured as quadlets, which are unit files that define the configuration for a Podman service. Quadlets are similar to systemd unit files, but they are specific to Podman and provide additional functionality for managing containers via systemd. Quadlets are stored in the `/home/mjdescy/.config/containers/systemd` directory, and they can be used to define the configuration for a Podman service, including the container image to use, the ports to expose, and the environment variables to set.

## Filesystems

The server contains two physical SSDs, one for the root filesystem and another for media storage. The root filesystem is formatted with Ext4, while the media storage is formatted with OpenZFS.

Ext4 is used for the root filesystem and other non-media storage needs, such as container storage, folders mounted to containers, and other system files. Importantly, SABNZBD downloads are stored on the root filesystem, and can be moved to the OpenZFS filesystem after download, either manually or automatically using services such as Sonarr and Radarr. The root filesystem is mounted on `/`. The disk is 512GB in size.

ZFS (specifically OpenZFS) is used for storage of all media files managed on the server. It provides advanced features such as snapshots, replication, and data integrity. ZFS snapshots are used to create backups of the media files, which can be restored in case of data loss or corruption. The ZFS snapshots are created automatically via Sanoid. The ZFS filesystem is mounted on `/tank`. It contains a tree of ZFS datasets. The disk is 4TB in size.

## Setup Instructions

1. [Install Debian][1]
2. [Install and configure OpenZFS][2]
3. [Install and configure Sanoid][3]
4. [Install and configure Podman and quadlets][4]

[1]: ./01%20Install%20Debian.md
[2]: ./02%20Install%20OpenZFS.md
[3]: ./03%20Install%20Sanoid.md
[4]: ./04%20Install%20Podman.md