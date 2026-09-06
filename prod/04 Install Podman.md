# Install Podman

All services on the prod server will be run in containers using Podman. Podman is a daemonless container engine for developing, managing, and running OCI Containers on your Linux System. Podman is a drop-in replacement for Docker, and it can be used to run containers without requiring a daemon to be running in the background. On prod, all the containers will run as rootless containers, which means that they will run as a non-root user and will not require root privileges to run. This provides an additional layer of security, as it reduces the attack surface of the system and limits the potential damage that can be done by a compromised container. For simplicity, we will run all containers as the same non-root user, which will be the user that was created during the Debian installation process. This user will have sudo privileges, which will allow it to perform administrative tasks when necessary. This is not the most secure configuration, as it is generally recommended to run containers as different users to limit the potential damage that can be done by a compromised container. However, for simplicity and ease of management, we will run all containers as the same user.

## Step 1: Configure the `mjdescy` user to run rootless containers

Enable lingering for the `mjdescy` user to allow rootless containers to run even when the user is not logged in. This is necessary for running containers as a non-root user, as it allows the user's session to persist even when they are not logged in.

    ```sh
    sudo loginctl enable-linger mjdescy
    ```

## Step 2: Allow non-root users to bind to ports below 1024

To allow for Caddy, running as a non-root user, to bind to ports below 1024, we need to set the `net.ipv4.ip_unprivileged_port_start` kernel parameter to 0. This allows non-root users to bind to any port, including those below 1024, which are typically reserved for privileged processes. This is necessary for running Caddy as a non-root user, as it needs to bind to ports 80 and 443 for HTTP and HTTPS traffic.

    ```sh
    echo 'net.ipv4.ip_unprivileged_port_start=0' | sudo tee /etc/sysctl.d/50-unprivileged-ports.conf
    sudo sysctl --system
    ```

## Step 3: Install necessary packages

The following command installs the necessary packages for running Podman and managing containers:

    ```sh
    sudo apt install -y podman 
    ```

## Step 4: Configure Podman quadlets

Podman services are configured using quadlets, which are unit files that define the configuration for a Podman service. Quadlets are similar to systemd unit files, but they are specific to Podman and provide additional functionality for managing containers. Quadlets are stored in the `/home/mjdescy/.config/containers/systemd` directory, and they can be used to define the configuration for a Podman service, including the container image to use, the ports to expose, and the environment variables to set.

### Step 4.1: Create the quadlets directory

Execute the following command as user `mjdescy` to create the quadlets directory:

    ```sh
    mkdir -p /home/mjdescy/.config/containers/systemd
    ```

### Step 4.2: Copy the quadlet files to the quadlets directory

The quadlet files are stored in the `prod/quadlets` directory in this repository. Assuming you are working on another computer and are connecting to the prod server via SSH, you can use the `rsync` command to copy the quadlet files from your local machine to the prod server. The following command copies the quadlet files to the quadlets directory on the prod server:

    ```sh
    rsync ./prod/quadlets/ mjdescy@prod:/home/mjdescy/.config/containers/systemd/
    ```

You may need to substitute `prod` with the actual hostname or IP address of the prod server, and you may need to provide the password for the `mjdescy` user on the prod server.

Additionally you may need to change the ownership of the quadlet files to the `mjdescy` user. Change the ownership of the quadlet files using the following command:

    ```sh
    sudo chown -R mjdescy:mjdescy /home/mjdescy/.config/containers/systemd
    ```

### Step 4.3: Copy the environment files and data directories to `/home/mjdescy/prod`

The environment files and data directories are stored in the `prod/env_data` directory in this repository. Create the `/home/mjdescy/prod` folder on prod and copy the entire folder tree to `/home/mjdescy/prod` using the following commands:

    ```sh
    ssh mjdescy@prod "mkdir -p /home/mjdescy/prod"
    rsync ./prod/env_data/ mjdescy@prod:/home/mjdescy/prod/
    ```

## Step 5: Enable and start the Podman services

Enable and start the Podman services using the following commands:

    ```sh
    systemctl --user start caddy
    systemctl --user start jellyfin
    systemctl --user start sabnzbd
    systemctl --user start radarr
    systemctl --user start sonarr
    systemctl --user start karakeep
    systemctl --user start paperless
    ```