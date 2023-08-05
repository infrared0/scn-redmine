# scn-redmine
Redmine container for Seattle Community Network

This is intended to be the thinnest shim possible on top of the Bitnami redmine container (https://hub.docker.com/r/bitnami/redmine/)
to support receiving email via IMAP and secure storage of secrets. When possible, follow the Bitnami instructions.

*Eventually* this project should also support tools to backup and recover the config and DB volumes.

## Usage

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

## Further Reading

* https://github.com/bitnami/containers/tree/main/bitnami/redmine#how-to-use-this-image
* https://bitnami.com/stack/redmine/containers
* https://www.redmine.org/projects/redmine/wiki/RedmineReceivingEmails
