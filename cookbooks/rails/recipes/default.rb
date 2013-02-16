# apps under upstart server so started on server restart

# TODO: deployer user hardcoded
["/u", "/u/apps"].each do |dir|
  directory dir do
    owner "deployer"
    group "deployer"
    mode 0775
  end
end

# NOTE: defined in ruby_webapp roles
applications = node[:rails][:apps]

applications.each do |app_name|

  app_root = "/u/apps/#{app_name}"
  shared_dir = "#{app_root}/shared"
  
  directory app_root do
    owner "deployer"
    group "deployer"
  end

  directory shared_dir do
    owner "deployer"
    group "deployer"
  end
  
  %w(config tmp sockets log pids system bin).each do |dir|
    directory "#{app_root}/shared/#{dir}" do
      recursive true
      owner "deployer"
      group "deployer"
    end
  end
  
  template "#{shared_dir}/config/unicorn.conf.rb" do
    mode 0644
    source "unicorn.conf.erb"
    variables :name => app_name, :app_root => app_root, :workers => 4
  end

  node.set[:rails][:apps_metadata][app_name]["app_root"]    = app_root
  node.set[:rails][:apps_metadata][app_name]["socket_path"] = "#{app_root}/shared/sockets"

end

include_recipe 'nginx'
