FROM docker.io/bitnami/redmine:5

RUN install_packages cron nano

# Other stuff to install?
# SMTP?
# specific config files?
# make other links to files in config?

# copt the imap script and create the crontab
# note: this only works on an empty crontab, otherwise crontab -l get get the existing ones.
COPY cron-imap.sh /opt/bitnami/redmine
RUN echo "*/5 * * * * root /opt/bitnami/redmine/cron-imap.sh >> /opt/bitnami/redmine/log/cron.log" | crontab -
