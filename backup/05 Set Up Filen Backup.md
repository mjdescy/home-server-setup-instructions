# Set Up Filen Backup

Filen is my main repository for personal files. A full backup of these personal files (which are a subset of all the files I store on Filen) is synced from the cloud to the backup server daily.

## Step 1: Install rclone from pre-compiled binary

Rclone 1.7.0 or later is required to set up a Filen remote. The version that Debian 13 supports is older, so Filen is not supported. Therefore, we have to install the most recent binary without using `apt`.

This install installs the latest `rclone` binary using only packages that come with Debian 13.

```sh
# download the latest rclone binary
wget https://downloads.rclone.org/rclone-current-linux-amd64.zip
# unzip the binary (without installing an additional package on Debian 13)
python3 -m zipfile -e rclone-current-linux-amd64.zip .
# copy the binary to /usr/bin
cd rclone-*-linux-amd64
sudo cp rclone /usr/bin/
sudo chown root:root /usr/bin/rclone
sudo chmod 755 /usr/bin/rclone
# install manpage
sudo mkdir -p /usr/local/share/man/man1
sudo cp rclone.1 /usr/local/share/man/man1/
sudo mandb
# delete downloads
cd ..
rm -rf rclone-*
```

## Step 2: Configure rclone to access Filen

```sh
rclone config
```

Add a new remote for Filen. Name the remote "filen". Enter your Filen email and password and API key when prompted. You need the FilenCLI set up, either on the same computer or on another compter, to extract your API key. The command is `filen export-api-key`.

After setting up the filen remote, test if it works with the command `rclone ls filen:/`.

## Step 3: Create a systemd service to sync from Filen to local

The service runs three `rclone sync` commands, syncing `filen:/docs/_inbox`, `filen:/docs/code`, and `filen:/docs/docs` to their matching folders under `/clientbackup/client/michael/filen`.

Because `rclone sync` removes files from the destination that no longer exist at the source, confirm the paths before enabling the timer.

Copy the files `filen-backup.service` and `filen-backup.timer` files to the directory `/etc/systemd/system/`.

Enable and start the timer.

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now filen-backup.timer
```
