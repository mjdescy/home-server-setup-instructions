# Install OpenZFS

All files backed up on the backup server are stored in ZFS datasets. ZFS is a combined file system and logical volume manager that provides high storage capacities, data integrity verification, and support for snapshots and clones. OpenZFS is the open-source implementation of the ZFS file system.

Clients will be backed up to the `clientbackup` ZFS pool, while servers will be backed up to the `serverbackup` ZFS pool. Each client and server will have its own dataset within the respective ZFS pool, and each dataset will have its own mount point. Client backups are expected to be performed using backup software such as rsync, borgbackup, Pika, DejaDup, or Arq Backup, while server backups are expected to be performed using ZFS replication via Syncoid.


## Step 1: Install necessary packages

The services we plan to run on the backup server are OpenSSH, OpenZFS, NFS, sanoid, rsync, and borgbackup. OpenSSH is installed during the Debian installation process. To reduce the number of installation commands, we will install the other packages in one command, as follows:

    ```sh
    sudo apt install -y linux-headers-$(uname -r) zfs-dkms zfsutils-linux zfs-zed nfs-kernel-server nfs-common rsync borgbackup
    ```

The `linux-headers-$(uname -r)` package is required for building the ZFS kernel module. The `zfs-dkms` package provides the ZFS kernel module, while the `zfsutils-linux` package provides the user-space utilities for managing ZFS. The `zfs-zed` package provides the ZFS Event Daemon, which monitors ZFS events and can trigger actions based on those events. The `nfs-kernel-server` and `nfs-common` packages provide NFS server and client functionality, respectively. The `rsync` package provides a utility for efficiently transferring and synchronizing files between systems. The `borgbackup` package provides a deduplicating backup program that supports compression and encryption.

The installation process for zfs-dkms may take a few minutes, as it compiles the ZFS kernel module for the current kernel version. Once the installation is complete, you can verify that the ZFS kernel module is loaded by running the following command:

    ```sh
    lsmod | grep zfs
    ```

Note that NFS is installed but we do not plan to enable it until we have a need for it. The NFS server is installed but not started, and the NFS client is installed but not configured.

## Step 2: Configure ZFS pools and datasets

For the backup server, we will create two ZFS pools: one for client backups and one for server backups. Each pool will have its own datasets for each user and computer being backed up. The ZFS pools and datasets will be created on the two 3.5" hard drives in the backup server.

### Step 2.1: Create folders for ZFS pools

Create folders for each ZFS pool on the backup server.

    ```sh
    sudo mkdir /clientbackup
    sudo mkdir /serverbackup
    ```

### Step 2.2: Create or import ZFS pools

Create or import ZFS pools for each backup client and server. If the zpools already exist, you can import them using the `zpool import` command. If they do not exist, you can create them using the `zpool create` command. 

The following commands import two ZFS pools named `clientbackup` and `serverbackup`:

    ```sh
    sudo zpool import clientbackup
    sudo zpool import serverbackup
    ```

The following commands create two ZFS pools named `clientbackup` and `serverbackup`, each with a mirrored configuration using two hard drives:

    ```sh
    sudo zpool create -m /clientbackup clientbackup mirror /dev/sda /dev/sdb
    sudo zpool create -m /serverbackup serverbackup mirror /dev/sdc /dev/sdd
    ```

### Step 2.3: Create ZFS datasets for each client plus computer being backed up

The ZFS datasets will be created for each backup client and server within the respective ZFS pools. Each dataset will have its own mount point, which is a folder where the dataset will be accessible in the file system. The mount points for the datasets will be created under the `/clientbackup` and `/serverbackup` folders.

As necessary, create ZFS datasets for each backup client (i.e., person) and computer or backup set within the respective ZFS pools, as follows:

    ```sh
    sudo zfs create clientbackup/client
    sudo zfs create clientbackup/client/asdescy
    sudo zfs create clientbackup/client/asdescy/macbookair
    sudo zfs create clientbackup/client/ejdescy
    sudo zfs create clientbackup/client/ejdescy/macbookair
    sudo zfs create clientbackup/client/mjdescy
    sudo zfs create clientbackup/client/mjdescy/macmini
    sudo zfs create clientbackup/client/mjdescy/thinkpad
    sudo zfs create clientbackup/client/swdescy
    sudo zfs create clientbackup/client/swdescy/macbookair
    sudo zfs create clientbackup/client/swdescy/thinkpad
    ```

## Step 2.4: Create ZFS datasets for each server being backed up

As necessary, create ZFS datasets for each server being backed up within the respective ZFS pools. 

    ```sh
    sudo zfs create serverbackup/server
    sudo zfs create serverbackup/server/prod
    ```
