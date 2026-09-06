# Add users

## Default user: mjdescy

The default user is created during the Debian installation process. This user has sudo privileges and can perform administrative tasks on the system. The default user is typically used for initial setup and configuration of the backup server.

## Users for backup clients

Each backup client (person in my family) has a dedicated user account on the backup server. These users are created without passwords and connect to the backup server via SSH using public key authentication. The following users are created for the backup clients:

- `swdescy` (UID: 1001) - for client backup
- `ejdescy` (UID: 1002) - for client backup
- `asdescy` (UID: 1003) - for client backup

Create the users on the backup server using the following commands:

    ```sh
    sudo useradd -m -s /bin/bash -u 1001 swdescy # for client backup
    sudo useradd -m -s /bin/bash -u 1002 ejdescy # for client backup
    sudo useradd -m -s /bin/bash -u 1003 asdescy # for client backup
    ```

## User for server backups

Each server being backed up also has a dedicated user account on the backup server. These users are created without passwords and connect to the backup server via SSH using public key authentication. The following user is created for the production server:

- `prod` (UID: 1004) - for server backup

Create the user on the backup server using the following command:

    ```sh
    sudo useradd -m -s /bin/bash -u 1004 prod # for server backup
    ```

## SSH key-based authentication

All backup users are expected to connect to the server via SSH using public key authentication. This means that each user will generate an SSH key pair on their client machine and copy the public key to the backup server's corresponding user account. This allows for secure, passwordless authentication when connecting to the backup server.

To prepare the backup server for SSH key-based authentication using one user account on the backup server with `sudo` privileges, create a `.ssh` directory for each user and set the appropriate permissions, as follows:

    ```sh
    sudo mkdir /home/asdescy/.ssh
    sudo touch /home/asdescy/.ssh/authorized_keys
    sudo chown -R asdescy:asdescy /home/asdescy/.ssh
    sudo chmod 700 /home/asdescy/.ssh
    sudo chmod 600 /home/asdescy/.ssh/authorized_keys

    sudo mkdir /home/ejdescy/.ssh
    sudo touch /home/ejdescy/.ssh/authorized_keys
    sudo chown -R ejdescy:ejdescy /home/ejdescy/.ssh
    sudo chmod 700 /home/ejdescy/.ssh
    sudo chmod 600 /home/ejdescy/.ssh/authorized_keys

    sudo mkdir /home/mjdescy/.ssh
    sudo touch /home/mjdescy/.ssh/authorized_keys
    sudo chown -R mjdescy:mjdescy /home/mjdescy/.ssh
    sudo chmod 700 /home/mjdescy/.ssh
    sudo chmod 600 /home/mjdescy/.ssh/authorized_keys

    sudo mkdir /home/swdescy/.ssh
    sudo touch /home/swdescy/.ssh/authorized_keys
    sudo chown -R swdescy:swdescy /home/swdescy/.ssh
    sudo chmod 700 /home/swdescy/.ssh
    sudo chmod 600 /home/swdescy/.ssh/authorized_keys

    sudo mkdir /home/prod/.ssh
    sudo touch /home/prod/.ssh/authorized_keys
    sudo chown -R prod:prod /home/prod/.ssh
    sudo chmod 700 /home/prod/.ssh
    sudo chmod 600 /home/prod/.ssh/authorized_keys
    ```

Then, set up SSH key-based authentication for each user. Generate an SSH key pair on each client and server, and copy the public keys to the backup server's corresponding user accounts. SSH keys can be copied by using the `ssh-copy-id` command or by manually appending the public key to the `authorized_keys` file on the backup server. For example, on each client/server, for each user account on the backup server, run:

    ```sh
    ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519 -N ""
    ssh-copy-id -i ~/.ssh/id_ed25519.pub user@backup-server-ip
    ```

In the example above, replace `user` with the username of the backup user account on the backup server (e.g., `swdescy`, `ejdescy`, `asdescy`, or `prod`), and replace `backup-server-ip` with the IP address or hostname of the backup server.

### SSH key for the production server backup (Syncoid)

The SSH key used for the production server backup is set up in the opposite direction from the client keys above. Syncoid runs on the backup server as the `prod` user and connects **to** the production server over SSH. The `prod` user on the backup server therefore needs an SSH key pair, and its **public** key must be installed in the `mjdescy` user's `authorized_keys` file on the production server.

Generate the SSH key pair for the `prod` user on the backup server:

    ```sh
    sudo -u prod ssh-keygen -t ed25519 -f /home/prod/.ssh/id_ed25519 -N ""
    ```

Install the public key in the `mjdescy` user's `authorized_keys` file on the production server. From the backup server, as the `prod` user, copy the public key to the production server:

    ```sh
    sudo -u prod ssh-copy-id -i /home/prod/.ssh/id_ed25519.pub mjdescy@prod.lan.19781013.xyz
    ```

Alternatively, manually append the contents of `/home/prod/.ssh/id_ed25519.pub` on the backup server to `/home/mjdescy/.ssh/authorized_keys` on the production server.

Verify that the `prod` user on the backup server can connect to the production server without a password:

    ```sh
    sudo -u prod ssh -i /home/prod/.ssh/id_ed25519 mjdescy@prod.lan.19781013.xyz
    ```

This is the SSH key referenced by the `SSH_KEY` variable in the Syncoid backup script (see [Install Sanoid and Syncoid][sanoid-syncoid]).

[sanoid-syncoid]: ./04%20Install%20Sanoid%20and%20Syncoid.md
