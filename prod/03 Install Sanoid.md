# Install Sanoid

Sanoid is a snapshot management tool for ZFS that allows you to automate the creation and pruning of snapshots. Syncoid is a tool for synchronizing ZFS datasets between two systems, allowing you to replicate data from one ZFS pool to another.

## Step 1: Install

Sanoid is installed via the `sanoid` package, which is available in the Debian repositories. Install Sanoid with the following command:

    ```sh
    sudo apt install -y sanoid
    ```

## Step 2: Configure Sanoid

On the backup server, the Sanoid configuration file is located at `/etc/sanoid/sanoid.conf`. This file contains the configuration for Sanoid, including the snapshot retention policies for each ZFS dataset.

### Step 2.1: Create a configuration file for Sanoid

Create a configuration file for sanoid at `/etc/sanoid/sanoid.conf` with the following content (it is important that autosnap is set to "yes" and autoprune is set to "yes"):

    ```ini
    [tank]
            use_template = production
            recursive = yes

    #############################
    # templates below this line #
    #############################

    # name your templates template_templatename. you can create your own, and use them in your module definitions above.

    [template_production]
            frequently = 0
            hourly = 0
            daily = 7
            weekly = 0
            monthly = 0
            yearly = 0
            autosnap = yes
            autoprune = yes
    ```

### Step 2.2: Enable the Sanoid timer service

Enable the sanoid timer service to run automatically at boot:

    ```sh
    sudo systemctl enable sanoid.timer
    sudo systemctl start sanoid.timer
    ```
