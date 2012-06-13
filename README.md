Chef Cookbooks in use at milaap.org. uses chef-solo

#### These Chef cookbooks assume the following:

* Ubuntu 12.04 (Precise)
* Chef-Solo 0.10.x Not using chef-server
* some data bags containing: users, groups, passwords, certificates,
  apps and known ssh keys
  most of them will not be committed in this repo

Uses bundler to lock the gem versions
It also uses rvm to specify the ruby version and to isolate gems in a
rvm gemset
Some files are under gitignore as well, particularly the data_bags

#### Directory Structure

* bootstrap: custom chef bootstrap scripts. they are based on the chef
  scripts. But they are specifically for chef-solo
* cookbooks: the chef cookbooks. will run with chef-solo
* data_bag: contains data_bags. some of the files may not be committed
  as they contain specific data
* script: some helper scripts. shef is particularly helpful to try out
  chef commands. eg. can play around with data_bag_item

#### Files of interest 

* solo.rb; config file for chef solo
* node.json: contains the run_list. can contain general attributes as well
  although we will be putting secret attributes in databags
* deploy.sh: "adhoc" script to run chef-solo on a node.
  can run in debug mode by
    > ./deploy.sh -l debug

Tried hosted chef and self-hosted chef-server before settling on
chef-solo. It is simple with most of the advantages of chef IMO.
ie. DSL for provisioning and the power of ruby.

The USP of chef-server seems to the search functionality and the fact
that it has node state information.
Might change my mind and go with chef-server, if there are more
servers to manage.

#### TODO

* add cookbooks :-)
