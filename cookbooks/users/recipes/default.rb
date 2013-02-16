# NOTE: install ruby-shadow gem for chef
chef_gem "ruby-shadow"

# NOTE: creates a group
group "admin"

node['users']['names'].each do |name, conf|
  # disable password login. can login via ssh key
  # the users app and deployer do not have bash autocomplete and a
  # bash prompt
  # users:
  # deployer: can apt-get and deploy software. has sudo perms
  # app: no sudo perms. perms only for the app to run
  # ftp: to copy static html files for sarath to "specific dirs"

  # NOTE: Look normal ruby. we are using a variable. You can do crazy
  # stuff eg. call a postgres database, call an API, call your own library 
  home_dir = "/home/#{name}"
  
  user name do
    shell "/bin/bash"
    # NOTE: sudo needs the users password. generated with "openssl passwd -1 '<password>'"
    password conf[:password] if conf[:password]
  end
  
  directory home_dir do
    owner name
    mode 0700
  end

  group "sudo-for-user-#{name}" do
    group_name "sudo"
    members name
    append  true
    action  [:modify]
    # TODO: does not work
    only_if do
      #breakpoint "sudo-for-user"
      conf['sudo']
    end
  end

  # make sure there is an entry for admin in sudoers file
  group "admin-for-user-#{name}" do
    group_name "admin"
    members name
    append  true
    action  [:modify]
    only_if do
      conf['admin']
    end
  end
  
  directory "#{home_dir}/.ssh" do
    owner name
    mode 0700
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    owner name
    mode 0600
  end

  template "#{home_dir}/.bash_aliases" do
    owner name
    mode 0700
  end

  # additioanlly sources .bash_aliases
  template "#{home_dir}/.profile" do
    owner name
    mode 0700
    
    # not needed as it is set with rbenv global now
    # and anyways setting RBENV_VERSION is a responsibility
    # of the ruby cookbook
    # variables(:set_rbenv_version => conf[:set_rbenv_version])
  end

  template "#{home_dir}/.gemrc" do
    owner name
    mode 0700
  end

  # TODO: after-hook after/if git is installed
  template "#{home_dir}/.gitconfig" do
    owner name
    mode 0700
  end
end
