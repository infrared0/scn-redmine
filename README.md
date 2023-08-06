# scn-redmine
Redmine container for Seattle Community Network

This is intended to be the thinnest shim possible on top of the Bitnami redmine container (https://hub.docker.com/r/bitnami/redmine/)
to support receiving email via IMAP and secure storage of secrets. When possible, follow the Bitnami instructions.

This project will also act as an example of best practices for minimalist container-based projects with support tools to backup and recover container volumes and other documented operating procedures.


## Usage

### Deploy

1. Clone the repo `git@github.com:philion/scn-redmine.git`.
2. Copy the `sample.env` file to `.env` and update the passwords:
```
git clone git@github.com:philion/scn-redmine.git redmine
cd redmine
cp sample.env .env
chmod 600 .env
vi .env
```
3. Update the file with the correct passwords:
```
REDMINE_SMTP_PASSWORD=your_password
REDMINE_IMAP_PASSWORD=your_password
```
4. Deploy into a standard Docker engine:
```
./cluster up
```

### Configure IMAP

Incoming IMAP email is handled by adding a cron job running on the Docker host:
```
sudo crontab -e
```
and add the following entry to the bottom:
```
*/5 * * * * docker exec -t redmine-redmine-1 /opt/bitnami/redmine/cron-imap.sh 2>&1 | /usr/bin/logger -t redmine-imap
```	
This cron job uses docker to execute the imap job inside the redmine container, and capture std and err output to syslog (tagged "redmine-imap").


### Backup and Restore

The provided `cluster` script handles creating backups and restoring the cluster state from them.

To create a backup:
```
./cluster backup
```
This will create a file named `clustername-datestamp.tgz`, where redmine-202308051251.tgz

To restore a cluster from backup:
```
./cluster restore backup-202308051251.tgz
```

### Standard Operation

The `cluster` script provides standard management operations:
```
cluster status        - what's the status of the cluster (default)
cluster up            - bring the entire cluster
cluster down          - bring the entire cluster down
cluster rebuild       - rebuild and start the cluster
cluster backup        - make a backup of the cluster
cluster restore <tgz> - restore a cluster from the given backup .tgz file
```

## Backup Process & Structure

The backup file is created by `cluster backup` is a gzipped tar file wrapping a gzipped tar file for each volume mentioned in the `docker-compose.yml`. It is automatically named with the cluster name (the parent directory of the compose yaml) and a to-the-minute precise datestamp.

The process for creating a backup:
1. Creating a new date-stamped dir from the parent-dir name (same as compose): name-YYYYMMDDHHMM
2. For each volume mentioned in the compose.yml
   2.1 Run an empty container, with the volume and the backup dir mounted
   2.2 Archive contents of volume: volume.tgz in the mounted backup dir, w/o parent-context
 3. tar-gzip the entire backyp dir into name-YYYYMMDDHHMM.tgz
    
Restoring the backup file with 'cluster restore backup-file.tgz'
1. Untar the backup file
2. For each tgz file in the backup:
   2.1 Confirm a matching entry in the compose file
   2.2 Run a simple container, mounting the volume and the backup
   2.3 Import the backup into the volume with tar on the specific volume
 3. Cleanup the backup dir (leaving the backup.tgz untouched)


## Further Reading

* https://github.com/bitnami/containers/tree/main/bitnami/redmine#how-to-use-this-image
* https://bitnami.com/stack/redmine/containers
* https://www.redmine.org/projects/redmine/wiki/RedmineReceivingEmails
* https://github.com/BretFisher/docker-vackup


## TODO

TODO: `vackup importall *redmine*` to GLOB expected files, derive the volume from the filename, and then import the tarfile
TODO: Update usage docs, with new cmds and input feedback	 
TODO add better usage
TODO migrate vackup functions to this one
TODO refactor backup package.
TODO better way to check status in the container. what are the expected services? parse the compose
TODO check for tools: docker, yq
TODO should the cluster script be verbose requarding the commands it issues?
