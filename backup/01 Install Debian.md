# Backup server installation

## Notes

The system drive on this server has to be a USB drive. There is an internal USB port on the motherboard that is used for this purpose. The USB drive should be at least 32GB in size and formatted with a Linux filesystem (ext4 is recommended).

The Debian 13 installer fails to detect the USB drive as a valid installation target for certain USB sticks. I had no luck with a Buffalo 500 GB SSD drive with a USB 3.0 interface, but a SanDisk 32 GB USB 3.0 drive worked fine. If you have trouble with booting from the USB drive after an installation, try a different USB drive. Do not both trying to get GRUB or extlinux to work on a USB drive that is not working after the first installation attempt. Just try a different USB drive.

## Step 1: Install Debian

1. Download the Debian 13 netinst ISO image from the official Debian website.
2. Create a bootable USB drive using the downloaded ISO image.
3. Put the destination USB drive into the internal USB port on the motherboard of the backup server.
4. Put the bootable USB drive with the Debian 13 installer into a USB port on the front of the backup server. You may need to change the boot order in the BIOS settings to boot from the USB drive.
5. Boot the server from the installer USB drive and follow the installation prompts.
6. During the installation, select the internal USB drive as the target for the system installation.
7. Do not set a root password during the installation. Instead, create a regular user account with administrative privileges (sudo access) for security reasons.
8. At the task selection screen, choose "SSH server" and "standard system utilities" to install the necessary packages for remote access and basic system functionality.
9. After the installation is complete, remove the installer USB drive and reboot the server. The system should boot from the internal USB drive.

## Step 2: Post-installation configuration

### Step 2.1: Add contributed repositories to the sources list

Add contributed repositories to the sources list for additional software packages such as OpenZFS.

```sh
sed -i 's/ main/ main contrib/g' /etc/apt/sources.list
```

### Step 2.2: Update the system packages

Update the system packages again to include the newly added repositories:

```sh
sudo apt update && sudo apt upgrade -y
```