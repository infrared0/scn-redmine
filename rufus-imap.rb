require 'rubygems'
require 'rake'
require 'rufus-scheduler'

load File.join(Rails.root, 'Rakefile')

ENV['host']='imap.gmail.com'
ENV['port']='993'
ENV['ssl']='true'
ENV['starttls']='true'
ENV['username']='redmine@seattlecommunitynetwork.org'
ENV['password']=ENV['REDMINE_IMAP_PASSWORD']

ENV['project']='scn'
ENV['unknown_user']='create'
ENV['status']='new'
ENV['tracker']='support'

scheduler = Rufus::Scheduler.new
# CONFIG Check emails every 5 mins
scheduler.interval '5m' do
  task = Rake.application['redmine:email:receive_imap']
  task.reenable
  task.invoke 
end
