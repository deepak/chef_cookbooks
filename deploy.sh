#!/usr/bin/env sh

cmd_options=$*
# TODO: have an array and iterate over
login="root@chef-client.milaap.org"

rsync -r . ${login}:/var/chef
echo 'sync done'

ssh ${login} "chef-solo $cmd_options -c /var/chef/solo.rb"