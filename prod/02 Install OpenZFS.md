# Install OpenZFS

All media files on the prod server are stored in ZFS datasets. ZFS is a combined file system and logical volume manager that provides high storage capacities, data integrity verification, and support for snapshots and clones. OpenZFS is the open-source implementation of the ZFS file system.

Media files are stored in the `tank` ZFS pool, which contains a tree of datasets for the various services running on the server. ZFS snapshots of the `tank` pool are created automatically via Sanoid and replicated to the backup server via Syncoid.

## Step 1: Install necessary packages

The services we plan to run on the prod server are OpenSSH, OpenZFS, NFS, sanoid, and rsync. OpenSSH is installed during the Debian installation process. To reduce the number of installation commands, we will install the other packages in one command, as follows:

    ```sh
    sudo apt install -y linux-headers-$(uname -r) zfs-dkms zfsutils-linux zfs-zed nfs-kernel-server nfs-common sanoid rsync
    ```

The `linux-headers-$(uname -r)` package is required for building the ZFS kernel module. The `zfs-dkms` package provides the ZFS kernel module, while the `zfsutils-linux` package provides the user-space utilities for managing ZFS. The `zfs-zed` package provides the ZFS Event Daemon, which monitors ZFS events and can trigger actions based on those events. The `nfs-kernel-server` and `nfs-common` packages provide NFS server and client functionality, respectively. The `sanoid` package provides Sanoid and Syncoid, which manage ZFS snapshots and replicate ZFS datasets between servers (configured in a later step). The `rsync` package provides a utility for efficiently transferring and synchronizing files between systems.

The installation process for zfs-dkms may take a few minutes, as it compiles the ZFS kernel module for the current kernel version. Once the installation is complete, you can verify that the ZFS kernel module is loaded by running the following command:

    ```sh
    lsmod | grep zfs
    ```

Note that NFS is installed but we do not plan to enable it until we have a need for it. The NFS server is installed but not started, and the NFS client is installed but not configured.

## Step 2: Configure ZFS pools and datasets

For the prod server, we will create one ZFS pool named `tank` for storing the server's data. Tank is a single-volume ZFS pool that will be created on the 4TB SSD in the prod server. ZFS is used for its advanced features such as data integrity, snapshots, and replication.

### Step 2.1: Create folders for ZFS pools

Create a folder for the ZFS pool.

    ```sh
    sudo mkdir /tank
    ```

### Step 2.2: Create or import ZFS pools

Create or import the ZFS pool for the prod server's data. If the pool already exists, you can import it using the `zpool import` command. If it does not exist, you can create it using the `zpool create` command. 

The following command imports the ZFS pool named `tank`:

    ```sh
    sudo zpool import tank
    ```

The following command creates a ZFS pool named `tank` on the 4TB SSD in the prod server:

    ```sh
    sudo zpool create -m /tank tank /dev/nvme0n1
    ```

### Step 2.3: Create ZFS datasets

The following commands create ZFS datasets for the various services that will run on the prod server:

    ```sh
    sudo zfs create tank/downloads
    sudo zfs create tank/paperless
    sudo zfs create tank/video
    sudo zfs create tank/video/home-videos
    sudo zfs create tank/video/movies
    sudo zfs create tank/video/tv
    ```
