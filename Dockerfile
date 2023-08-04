FROM docker.io/bitnami/redmine:latest

#RUN install_packages cron nano

# Other stuff to install?
# SMTP?
# specific config files?
# make other links to files in config?

# install scheduler, as per 
# https://www.redmine.org/projects/redmine/wiki/redminereceivingemails#Schedule-email-receiving-with-Rufus-Scheduler
RUN gem install rufus-scheduler
RUN mkdir -p /bitnami/redmine/config/initializers/
COPY rufus-imap.rb /bitnami/redmine/config/initializers/
RUN ln -s /bitnami/redmine/config/initializers/rufus-imap.rb /opt/bitnami/redmine/config/rufus-imap.rb
