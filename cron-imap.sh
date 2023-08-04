#!/bin/bash

## This is intended to run the redmine rake job
## on the redmine server to update issues from rmail.
##
## install with: 
##     echo "* * * * * /opt/bitnami/redmine/cron-imap.sh" > /etc/crontabs/root

cd /opt/bitnami/redmine
bundle exec rake redmine:email:receive_imap --trace RAILS_ENV="production" host=imap.gmail.com port=993 username=redmine@seattlecommunitynetwork.org password=$REDMINE_IMAP_PASSWORD ssl=true project=scn unknown_user=accept >> /opt/bitnami/redmine/log/imap.log 2>&1
