FROM docker.io/bitnami/redmine:5

RUN install_packages cron nano

# Other stuff to install?
# SMTP?
# specific config files?
# make other links to files in config?

# copt the imap script and create the crontab
# note: this only works on an empty crontab, otherwise crontab -l get get the existing ones.
COPY cron-imap.sh /opt/bitnami/redmine
RUN echo "*/5 * * * * redmine /opt/bitnami/redmine/cron-imap.sh" | crontab -

RUN service cron start

# NOTE TO SELF: the rufus-imap.rb seems to be breaking the db migration. perhaps some syntax error that's not logged.
# install scheduler, as per 
# https://www.redmine.org/projects/redmine/wiki/redminereceivingemails#Schedule-email-receiving-with-Rufus-Scheduler

#RUN gem install rufus-scheduler

#RUN echo copying rufus-imap.rb info /opt/bitnami/redmine/config/initializers/
#COPY rufus-imap.rb /opt/bitnami/redmine/config/initializers/rufus-imap.rb

# NOTE: ln -s doesn't work, and if needed, append the file to env REDMINE_DATA_TO_PERSIST:
#ENV REDMINE_DATA_TO_PERSIST="$REDMINE_DATA_TO_PERSIST:config/initializers/rufus-imap.rb"
#RUN ln -s /opt/bitnami/redmine/config/initializers/rufus-imap.rb /bitnami/redmine/config/rufus-imap.rb
