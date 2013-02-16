# fork of
# https://github.com/jamesotron/cookbooks/blob/master/timezone/recipes/default.rb
# http://community.opscode.com/cookbooks/timezone

if ['debian','ubuntu'].member? node[:platform]
  # Make sure it's installed. It would be a pretty broken system
  # that didn't have it.
  package "tzdata"

  link "/etc/localtime" do
    owner 'root'
    group 'root'
    mode 0644
    filename = "/usr/share/zoneinfo/#{node[:timezone]}"
    to filename
    only_if do
      # TODO: do not run even if files are the same. advantage is that dpkg-reconfigure 
      # can be skipped
      check =  File.exists? filename
      raise "timezone #{node[:timezone]} does not exist" unless check 
      check
    end
    notifies :run, 'bash[dpkg-reconfigure tzdata]'
  end

  # NOTE: changes "date +%Z"
  bash 'dpkg-reconfigure tzdata' do
    user 'root'
    code "/usr/sbin/dpkg-reconfigure -f noninteractive tzdata"
    action :nothing
  end

end
