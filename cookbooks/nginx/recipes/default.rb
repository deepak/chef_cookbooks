apt_repository "nginx-stable" do
  uri "http://ppa.launchpad.net/nginx/stable/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "C300EE8C"
  notifies :run, resources(:execute => "apt-get-update"), :immediately
end

package "nginx"

service "nginx" do
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end

template "/etc/nginx/nginx.conf" do
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[nginx]"
end

# TODO: do we reload here ? :-)
link "/etc/nginx/sites-enabled/default" do
  action :delete
end

applications = node[:rails][:apps]

metadata = node[:rails][:apps_metadata]

applications.each do |app_name|
  template "/etc/nginx/sites-available/#{app_name}" do
    owner "root"
    group "root"
    mode 0644
    # TODO: how to DRY up with the rails cookbook
    # upstream milaap_webapp_server
    # server unix:/u/apps/milaap-webapp/shared/sockets/unicorn.sock fail_timeout=0;
    variables(:app_name => app_name.gsub('-', '_'),
              :app_root => metadata[app_name]["app_root"],
              :socket_path => metadata[app_name]["socket_path"],
              :workers => 4)
  end

  # TODO: check that nginx not started every time
  link "/etc/nginx/sites-enabled/#{app_name}" do
    to "/etc/nginx/sites-available/#{app_name}"
    notifies :reload, "service[nginx]"
  end
end
