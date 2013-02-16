include_recipe 'apt'

apt_repository 'chris-lea-node' do
  uri 'http://ppa.launchpad.net/chris-lea/node.js/ubuntu'
  distribution node[:lsb][:codename]
  components %w(main)
  keyserver 'keyserver.ubuntu.com'
  key 'C7917B12'
  action :add
end

# installing it for precompiling assets for rails asset-pipeline
package "nodejs"
