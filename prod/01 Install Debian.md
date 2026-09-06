# Prod server installation

## Notes

This is a straightforward installation of Debian 13.

## Step 1: Install Debian

1. Download the Debian 13 netinst ISO image from the official Debian website.
2. Create a bootable USB drive using the downloaded ISO image.
3. Put the bootable USB drive with the Debian 13 installer into any USB port. You may need to change the boot order in the BIOS settings to boot from the USB drive.
4. Boot the server from the installer USB drive and follow the installation prompts.
5. During the installation, make sure to select the correct drive as the target for the system installation.
6. Do not set a root password during the installation. Instead, create a regular user account with administrative privileges (sudo access) for security reasons.
7. At the task selection screen, choose "SSH server" and "standard system utilities" to install the necessary packages for remote access and basic system functionality.
8. After the installation is complete, remove the installer USB drive and reboot the server. The system should boot from the internal SSD.

## Step 2: Post-installation configuration

### Step 2.1: Add contributed repositories to the sources list

Add contributed repositories to the sources list for additional software packages such as OpenZFS.

```sh
sudo sed -i 's/ main/ main contrib/g' /etc/apt/sources.list
```

### Step 2.2: Update the system packages

Update the system packages again to include the newly added repositories:

```sh
sudo apt update && sudo apt upgrade -y
```
