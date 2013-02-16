default['postgresql']['version'] = '9.2'
default['postgresql']['dir'] = "/etc/postgresql/#{node['postgresql']['version']}/main"

default['postgresql']['password']['postgres'] = '<some-password> CHANGE IT'
default['postgresql']['password']['app']   = '<some-password> CHANGE IT'
