# scn-redmine
Redmine container for Seattle Community Network

This is intended to be the thinnest shim possible on top of the Bitnami redmine container (https://hub.docker.com/r/bitnami/redmine/)
to support receiving email via IMAP and secure storage of secrets. When possible, follow the Bitnami instructions.

This project will also act as an example of best practices for minimalist container-based projects with support tools to backup and recover container volumes and other documented operating procedures.

## Usage

### Deploy

Copy the `sample.env` file to `.env`, and update the passwords
    
    cp sample.env .env
    chmod 600 .env
    vi .env

And update the file with the correct passwords

    REDMINE_SMTP_PASSWORD=your_password
    REDMINE_IMAP_PASSWORD=your_password

Deploy into a standard Docker engine with:
    
    sudo docker compose up -d
		
Incoming IMAP email is handled by adding a cron job running on the Docker host:

    sudo crontab -e

and add the following entry to the bottom:

    */5 * * * * docker exec -t redmine-redmine-1 /opt/bitnami/redmine/cron-imap.sh 2>&1 | /usr/bin/logger -t redmine-imap
		
This cron job uses docker to execute the imap job inside the redmine container, and capture std and err output to syslog (tagged "redmine-imap").

### Backup and Restore

A script called `vackup` is included to support backing-up and restoring the volumes used in the redmine deployment.

To create a backup for the `redmine` specific volumes:

    sudo vackup exall redmine
		
This will create a backup file for each volume the filter matches, of the form `<volume>-<datestamp>.tgz`.
		
The `exall` is for "export all". The `export` command is for specific volumes.
		
> Note that "redmine" is a string that is used to match volumes names as per https://docs.docker.com/engine/reference/commandline/volume_ls/#filter.

To load a backup tarfile back into a volume, specify `import` followed by the `<file>` and `<volume>` to load to backup into,

    sudo vackup import redmine_mariadb_data-202308051251.tgz redmine_mariadb_data
		
		
## Further Reading

* https://github.com/bitnami/containers/tree/main/bitnami/redmine#how-to-use-this-image
* https://bitnami.com/stack/redmine/containers
* https://www.redmine.org/projects/redmine/wiki/RedmineReceivingEmails
* https://github.com/BretFisher/docker-vackup


## TODO

Complete refactoring of vackup into "cluster", to provide a generalized shim on top on any container engine (currently docker) to help make SOPs easier.

TODO: `vackup importall *redmine*` to GLOB expected files, derive the volume from the filename, and then import the tarfile
TODO: Update usage docs, with new cmds and input feedback
    
A simple script to help with cluster management

   cluster status        - what's the status of the cluster (default)
   cluster up            - bring the entire cluster
   cluster down          - bring the entire cluster down
   cluster rebuild       - rebuild and start the cluster
   cluster backup        - make a backup of the cluster
   cluster restore <tgz> - restore a cluster from the given backup .tgz file
		 
TODO add better usage
TODO migrate vackup functions to this one
TODO refactor backup package.
TODO better way to check status in the container. what are the expected services? parse the compose
TODO check for tools: docker, yq
TODO should the cluster script be verbose requarding the commands it issues?
