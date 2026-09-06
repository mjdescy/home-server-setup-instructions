# Install Sanoid and Syncoid

Sanoid is a snapshot management tool for ZFS that allows you to automate the creation and pruning of snapshots. Syncoid is a tool for synchronizing ZFS datasets between two systems, allowing you to replicate data from one ZFS pool to another.

Syncoid is a wrapper around the `zfs send` and `zfs receive` commands, which are used to send and receive ZFS snapshots. Syncoid can be used to replicate data from one ZFS pool to another, either locally or over a network.

## Step 1: Install Sanoid and Syncoid

Both Sanoid and Syncoid are installed via the `sanoid` package, which is available in the Debian repositories. The `sanoid` package includes both Sanoid and Syncoid, as well as a configuration file for Sanoid.

This package was already installed in the previous step when we installed the `zfsutils-linux` package, which is a dependency of the `sanoid` package. If you have not yet installed the `sanoid` package, you can do so by running the following command:

```sh
sudo apt install -y sanoid
```

## Step 3: Configure Sanoid

On the backup server, the Sanoid configuration file is located at `/etc/sanoid/sanoid.conf`. This file contains the configuration for Sanoid, including the snapshot retention policies for each ZFS dataset.

### Step 3.1: Create a configuration file for Sanoid

Create a configuration file for sanoid at `/etc/sanoid/sanoid.conf` with the following content (it is important that autosnap is set to "no" and autoprune is set to "yes"):

    ```ini
    [serverbackup]
            use_template = backup
            recursive = yes
            process_children_only = yes

    [clientbackup]
            use_template = backup
            recursive = yes
            process_children_only = yes

    [template_backup]
            frequently = 0
            hourly = 0
            daily = 7
            weekly = 0
            monthly = 0
            yearly = 0
            autosnap = no
            autoprune = yes
    ```

### Step 2.2: Enable the Sanoid timer service

Enable the sanoid timer service to run automatically at boot:

    ```sh
    sudo systemctl enable sanoid.timer
    sudo systemctl start sanoid.timer
    ```

## Step 3: Configure user account for Syncoid

Grant the backup user (prod) passwordless sudo access to run syncoid commands. Edit the sudoers file using the `visudo` command:

    ```sh
    sudo visudo -f /etc/sudoers.d/syncoid
    ```

Then add the following line to the file:

    ```text
    prod ALL=(ALL) NOPASSWD: /usr/sbin/syncoid
    ```

Exit Vim and save the file via (ESC) `:wq`. This allows the prod user to run syncoid commands without being prompted for a password, which is necessary for automated backups.

## Step 4: Configure Syncoid

### Step 4.1: Create a script for Syncoid backups

Create a file at `/usr/local/sbin/syncoid-backup.sh` with the following content to run syncoid backups:

    ```bash
    #!/usr/bin/env bash
    # /usr/local/sbin/syncoid-backup.sh
    # Edit these lines as your "configuration":
    SSH_KEY="/home/prod/.ssh/syncoid_ed25519"
    SOURCE="tank"
    TARGET="serverbackup/server/prod/tank"

    exec /usr/sbin/syncoid \
        --sshkey="$SSH_KEY" \
        --recursive \
        --no-sync-snap \
        "$SOURCE" "$TARGET"
    ```

Note: In the example above, replace `tank` with the name of the ZFS pool on the production server that you want to back up, and replace `serverbackup/server/prod/tank` with the path to the ZFS dataset on the backup server where you want to store the backup. You may also need to adjust the `SSH_KEY` variable to point to the correct SSH key for the backup user on the production server.

### Step 4.2: Create a systemd service for Syncoid backups

Create a file at `/etc/systemd/system/syncoid-backup.service` with the following content to define the syncoid backup service:

    ```ini
    [Unit]
    Description=ZFS replication with syncoid
    After=network-online.target
    Wants=network-online.target

    [Service]
    Type=oneshot
    ExecStart=/usr/local/sbin/syncoid-backup.sh
    # Run a second pass to catch snapshots created mid-run (optional):
    # ExecStart=/usr/local/sbin/syncoid-backup.sh
    Nice=19
    IOSchedulingClass=idle
    ```

### Step 4.3: Create a systemd timer for Syncoid backups

Create a file at `/etc/systemd/system/syncoid-backup.timer` with the following content to schedule syncoid backups:

    ```ini
    [Unit]
    Description=Run syncoid backup every day at 2:00 AM

    [Timer]
    OnCalendar=*-*-* 02:00:00
    Persistent=true

    [Install]
    WantedBy=timers.target
    ```

### Step 4.4: Start the Syncoid backup timer

To start the syncoid backup timer, run the following commands:

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now syncoid-backup.timer
sudo systemctl start syncoid-backup.service   # manual first run
journalctl -u syncoid-backup.service -f
```
