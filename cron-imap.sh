#!/bin/bash

## This is intended to run the redmine rake job
## on the redmine server to update issues from rmail.
##
## install with: 
##     echo "* * * * * /opt/bitnami/redmine/cron-imap.sh" > /etc/crontabs/root

cd /opt/bitnami/redmine
rake -f /usr/src/redmine/Rakefile redmine:email:receive_imap rails_env=production host=imap.gmail.com username=redmine@seattlecommunitynetwork.org password=your_password port=993 ssl=true project=scn no_permission_check=1 unknown_user=accept move_on_success=read >> /opt/bitnami/redmine/log/imap.log 2>&1