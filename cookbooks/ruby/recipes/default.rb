# inspired by https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer
# and github.com/RiotGames/rbenv-cookbook

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
#include_recipe "rbenv::ohai_plugin"

ruby_version = node['ruby']['app']['version']
rbenv_ruby ruby_version

bash "set default ruby version with rbenv" do
  user "root"
  group "root"
  code "rbenv init -; rbenv global #{ruby_version}; rbenv versions"
  notifies :create, "ruby_block[set_rbenv_version]", :immediately
end

ruby_block "set_rbenv_version" do
  block do
    ENV['RBENV_VERSION'] = ruby_version
  end
  action :nothing
end

# https://github.com/sstephenson/rbenv-vars
# "Variables specified in the ~/.rbenv/vars file will be set
# first. Then variables specified in .rbenv-vars files in any parent
# directories of the current directory will be set. Variables from the
# .rbenv-vars file in the current directory are set last."
# # NOTE: do not like the precedence matching. would like it to be simpler

include_recipe "rbenv::rbenv_vars"
