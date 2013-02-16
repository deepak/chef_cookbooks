include_recipe 'apt'

apt_repository 'pitti-postgresql' do
  uri 'http://ppa.launchpad.net/pitti/postgresql/ubuntu'
  distribution node[:lsb][:codename]
  components %w(main)
  keyserver 'keyserver.ubuntu.com'
  key '8683D8A2'
  action :add
end

# client

# psql client
package "postgresql-client"

# development header files
package "libpq-dev"

# server
package "postgresql-#{node['postgresql']['version']}"
# package "postgresql-9.2"

service "postgresql" do
  service_name "postgresql"
  supports :restart => true, :status => true, :reload => true
  action [:enable, :start]
end

# # TODO: check this if postgres version is changed
# # local has peer by default. allowed md5 as well
template "#{node['postgresql']['dir']}/pg_hba.conf" do
  source "pg_hba_#{node['postgresql']['version']}.conf.erb"
  owner "postgres"
  group "postgres"
  mode 00600
  notifies :reload, 'service[postgresql]', :immediately
end

# Default PostgreSQL install has 'ident' checking on unix user 'postgres'
# and 'md5' password checking with connections from 'localhost'. This script
# runs as user 'postgres', so we can execute the 'role' and 'database' resources
# as 'root' later on, passing the below credentials in the PG client.
bash "assign-postgres-password" do
  user 'postgres'
  code <<-EOH
echo "ALTER ROLE postgres ENCRYPTED PASSWORD '#{node['postgresql']['password']['postgres']}';" | psql
  EOH
  not_if "echo '\connect' | PGPASSWORD=#{node['postgresql']['password']['postgres']} psql --username=postgres --no-password -h localhost"
  action :run
end

bash "create-postgres-user-app" do
  user 'postgres'
  code <<-EOH
echo "CREATE ROLE app SUPERUSER LOGIN ENCRYPTED PASSWORD '#{node['postgresql']['password']['app']}';" | psql
  EOH
  not_if "echo '\connect' | PGPASSWORD=#{node['postgresql']['password']['postgres']} psql --username=postgres --no-password -h localhost"
  action :run
end
