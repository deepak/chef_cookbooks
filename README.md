Chef Cookbooks in use at milaap.org. Uses chef-solo  
http://wiki.opscode.com/display/chef/Home

#### These Chef cookbooks assume the following:

* Ubuntu 12.04 (Precise), a Linux distribution
* Chef-Solo 0.10.x Not using chef-server
* Some data bags containing: users, groups, passwords, certificates,  
  apps and known ssh keys  
  none of them will not be committed in this repo  
* Chef works on Amazon ec2, Rackspace etc, but we use the rackspace  
  cloud and have tested this code on Rackspace only

Uses bundler to lock the gem versions  
It also uses rvm to specify the ruby version and to isolate gems in a
rvm gemset  
Some files are under gitignore as well, particularly the data_bags

Note that scripts have shebang not filename extensions. Advantage is  
that can move from a bash script to a ruby script without changing the  
filename.

#### Directory Structure

* bootstraps: custom chef bootstrap scripts. they are based on the  
  chef scripts. They are specifically for chef-solo
* cookbooks: the chef cookbooks. will run with chef-solo  
* data_bags: contains data_bags. some of the files may not be committed  
  as they contain specific data
* script: some helper scripts. shef is particularly helpful to try out  
  chef commands. eg. can play around with data_bag_item

#### Files of interest 

* solo.rb; config file for chef solo
* node.json: contains the run_list. can contain general attributes as  
  well although we will be putting secret attributes in databags
* deploy.sh: "adhoc" script to run chef-solo on a node.  
  can run in debug mode by  
    > ./deploy.sh -l debug  

Tried hosted chef and self-hosted chef-server before settling on  
chef-solo. It is simple with most of the advantages of chef IMO.  
ie. DSL for provisioning, the power of ruby and the community  
contributed cookbooks.

The USP of chef-server seems to the search functionality over the  
entire infrastructure. Which can be used to build dynamic  
and fast-changing topologies. It has many moving parts as well.  
Our requirements are simple and chef-solo seemed like a better fit.   

May go with chef-server, if there are more servers to manage.

#### Philosophy

* hopefully will try to keep it as simple as possible
* a good README file so others can follow along
* use chef-solo not chef-server

#### TODO

* add cookbooks :-)

#### Attribution

* the format of the README is inspired from the 37signals cookbook
