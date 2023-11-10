FROM docker.io/bitnami/redmine:5

RUN install_packages curl 
# install_packages cron && service enable cron && service start cron

# copy the imap script and create the crontab
# this only works on an empty crontab in the fresh container
COPY cron-imap.sh /opt/bitnami/redmine
#RUN echo "*/5 * * * * root /opt/bitnami/redmine/cron-imap.sh 2>&1 | /usr/bin/logger -t redmine-imap" | crontab -

# Replace the english locales file with one that replaces "issue" with "ticket"
COPY en.yml /opt/bitnami/redmine/config/locales/en.yml

# NOTE: This seems to build the container correctly with config as expected
# but it never invokes the script. So the readme calls for running cron in host.
# The cron-imap.sh script is used to encapsulate the imap creds in the container.