# Backup

## Details

| Hostname | Domain Name             | Description                                                  | Operating System |
| -------- | ----------------------- | ------------------------------------------------------------ | ---------------- |
| backup   | backup.lan.19781013.xyz | Backup server for the production server and client computers | Debian 13        |

## Hardware Specifications

| Manufacturer | Model                     | Processor     | RAM  | System Disk | Storage Disks | Network Interfaces                                |
| ------------ | ------------------------- | ------------- | ---- | ----------- | ------------- | ------------------------------------------------- |
| HP           | ProLiant MicroServer N54L | AMD Phenom II | 16GB | 1x 64GB USB | 4x 4TB HDD    | 1x Gigabit Ethernet; 1x WiFi 6 (currently unused) |

## Purpose

The backup server is a HP ProLiant MicroServer N54L. Its boot drive is a USB flash drive, and it has four 3.5" hard drives for storage. The server is configured to provide redundancy and data protection for the production server and client machines on the local network, ensuring that critical data is safe in case of hardware failure or other issues.

## Services

The following services are hosted on the backup server and are run natively and were installed via the Debian package manager:

- Secure file transfer for backup and ZFS replication: OpenSSH
- Backup: rsync
- Backup: borgbackup
- File sharing: NFS (available but not enabled; not meant to be used for backups)

Non-essential services are not installed on the backup server to minimize the attack surface and reduce the risk of security vulnerabilities. The backup server is configured to be secure and reliable, providing peace of mind that critical data is protected.

## Filesystems

The backup server is configured to use ZFS for data storage, which provides advanced features such as data integrity, snapshots, and replication. The backup server is also configured to use Sanoid and Syncoid for automated snapshot management and replication of ZFS datasets between the production server and the backup server.

Client machines on the local network can also be backed up to the backup server using various backup software, such as rsync, borgbackup, Pika, DejaDup, or Arq Backup. These clients primarily use SFTP to transfer data to the backup server, which provides secure and encrypted file transfer over the network. Each client machine has its own dedicated user account on the backup server for secure and isolated backups.

## Data Transfer and Security

All data transfer between the production server, backup server, and client machines is intended to be done via SFTP, which provides secure and encrypted file transfer over the network. The backup server is configured to allow SFTP access for authorized users, ensuring that data is transferred securely and protected from unauthorized access. Borgbackup and rsync are configured on the server and are intended to be accessed via SFTP for secure and encrypted file transfer.

NFS is installed on the server to allow for file shares to be created if necessary for data recovery or other purposes. However, NFS is not intended to be used for regular backups, as it does not provide the same level of security and data integrity as SFTP or ZFS.

## Setup Instructions

1. [Install Debian][1]
2. [Install and configure OpenZFS][2]
3. [Add users][3]
4. [Install and configure Sanoid and Syncoid][4]

[1]: ./01%20Install%20Debian.md
[2]: ./02%20Install%20OpenZFS.md
[3]: ./03%20Add%20Users.md
[4]: ./04%20Install%20Sanoid%20and%20Syncoid.md