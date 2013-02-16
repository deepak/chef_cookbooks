#
# Chef-Solo Capistrano Bootstrap
#
# usage:
#    SERVER_NAME=<server-name> cap chef:bootstrap
# <server-name> is an entry in dna/nodes.yml
# the dna file is tried at dna/#{server-name}.json  
# otherwise the default is taken at dna.json
# 

# sequence of commands
# 1. run once
#    SERVER_NAME=server1.acme.com cap chef:ssh_copy_id
# 2. SERVER_NAME=server1.acme.com cap chef:init_serv
# 3. SERVER_NAME=server1.acme.com cap chef:bootstrap

# TODO:
# SERVER_NAME=all cap chef:bootstrap

require 'yaml'

# configuration
default_run_options[:pty] = true # fix to display interactive password prompts

# enable ssh port-forwarding. this way do not need to authenticate
# every node to github. the key only needs to exist on one machine
ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh", "id_rsa")]

def usage
  puts <<-USAGE
  usage:
     SERVER_NAME=<server-name> cap chef:bootstrap
  
  <server-name> is an entry in dna/nodes.yml
  the dna file is tried at dna/#{server-name}.json  
  otherwise the default is taken at dna.json
  USAGE
end

NODES = YAML.load_file('dna/nodes.yml')

set :user, "root"
set :port, 22

node_fqdn = ENV['SERVER_NAME']
target = NODES[node_fqdn] && NODES[node_fqdn]["ip_address"]

#if "all" == node_fqdn
#  target = NODES.map {|_,v| v["ip_address"] }.uniq.compact
#end

if target
  puts "node ip-address is #{target.inspect}"
else
  puts "[ERROR] CLI arguments not proper"
  usage
  return
end
role :target, target

if File.exists?("dna/#{node_fqdn}.json")
  dna_file = "dna/#{node_fqdn}.json"
else
  puts "default dna.json"
  dna_file = "dna.json"
end

namespace :chef do

  desc "Initialize a fresh Ubuntu 12.04 LTS install for chef"
  task :init_server, roles: :target do
    # create users, groups, upload pubkey, etc.

    # not idempotent. run it manually once
    # ssh_copy_id
    
    configure_gemrc
    install_packages

    status, msg = add_to_known_host "github.com"
    unless status
      puts "[ERROR] #{msg}"
      next
    end

    install_chef
    create_chef_cookbook
  end

  # NOTE: not idempotent. do not care as the first cgef run will
  # override it anyways
  desc "install your public key in a remote machine's authorized_keys"
  task :ssh_copy_id, roles: :target do
    find_servers_for_task(current_task).each do |server|
      puts `ssh-copy-id #{user}@#{server}`
    end
  end
  
  # desc "install your public key in a remote machine's authorized_keys"
  # task :ssh_copy_id, roles: :target do
  #   pub_key = `cat ~/.ssh/id_rsa.pub`
  #   conf_file = "~/.ssh/authorized-keys"
  #   # cat ~/.ssh/id_dsa.pub | ssh user@remotehost "cat - >> ~/.ssh/authorized_keys"  
  #   run "echo '#{pub_key.shellescape} | sort -u - #{conf_file} > /tmp/ssh"
  # end
    
  desc "Bootstrap an Ubuntu 12.04 server and kick-start Chef-Solo"
  task :bootstrap, roles: :target do
    sync_chef_cookbook
    run_chef
    puts "chef:bootstrap done"
  end

  desc "create chef cookbook to /vagrant"
  task :create_chef_cookbook, roles: :target do
    begin
      run "git clone --quiet https://github.com/deepak/chef_cookbooks.git /vagrant && echo 'git clone done'"
    rescue Capistrano::Error
      puts "handeling create_chef_cookbook. most probably /vagrant dir already exists"
      sync_chef_cookbook
    end
  end

  desc "sync chef cookbook with its git url"
  task :sync_chef_cookbook, roles: :target do
    run "cd /vagrant && git pull --quiet --rebase"
  end

  task :install_chef, roles: :target do
    run "curl -L https://www.opscode.com/chef/install.sh | sudo bash"
  end

  task :run_chef, roles: :target do
    run "cd /vagrant && ./bin/chef"
  end
  
  # chef is distributed as gem. we do not want to download ri and rdoc
  # files. for faster download as network IO will be reduced
  task :configure_gemrc, roles: :target do
    gemrc = <<-CONFIG
install: --no-rdoc --no-ri 
update:  --no-rdoc --no-ri
CONFIG
    run "echo '#{gemrc}' > ~/.gemrc"
  end

  # needed to install chef
  task :install_packages, roles: :target do
    mrun [
          "apt-get install -y --quiet curl",
          "apt-get install -y --quiet git"
         ]
  end
end

# helpers
def sudo_env(cmd)
  run "#{sudo} -i #{cmd}"
end

def msudo(cmds)
  cmds.each do |cmd|
    sudo cmd
  end
end

def mrun(cmds)
  cmds.each do |cmd|
    run cmd
  end
end

def rsync(from, to)
  find_servers_for_task(current_task).each do |server|
    puts `rsync -avz -e "ssh -p#{port}" "#{from}" "#{ENV['USER']}@#{server}:#{to}" \
      --exclude ".svn" --exclude ".git"`
  end
end

def bash(cmd)
  run %Q(echo "#{cmd}" > /tmp/bash)
  run "sh /tmp/bash"
  #run "rm /tmp/bash"
end

def bash_sudo(cmd)
  run %Q(echo "#{cmd}" > /tmp/bash)
  sudo_env "sh /tmp/bash"
  run "rm /tmp/bash"
end

# http://community.opscode.com/cookbooks/known_host/source
# http://serverfault.com/questions/132970/can-i-automatically-add-a-new-host-to-known-hosts
def add_to_known_host host
  key = `ssh-keyscan -H #{host} 2>&1`
  comment = key.split("\n").first

  if key =~ /^getaddrinfo/
    return [false, "Could not resolve #{host}"]
  end

  conf_file = "/etc/ssh/ssh_known_hosts"

  # adds only if not already added 
  mrun [
        "touch #{conf_file}",
        "ssh-keyscan -H #{host} 2>&1 | sort -u - #{conf_file} > #{conf_file}"
       ]
  
  # "ssh-keyscan -t rsa,dsa #{host} 2>&1 | sort -u - #{conf_file} > #{conf_file}"
  #run "[ ! -s #{conf_file} ] && echo '# This file must contain at least one line. This is that line.' > #{conf_file}"
  #run "if ! grep -q '#{host}' #{conf_file}; then echo '#{key}' >> #{conf_file}; fi"
  
  [true, "#{host} resolved"]
end

# https://help.github.com/articles/generating-ssh-keys
def verify_github_added_to_known_host host
  run "ssh -T git@github.com"
end
