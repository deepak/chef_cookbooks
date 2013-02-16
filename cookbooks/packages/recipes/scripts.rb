scripts_dir = node['packages']['scripts_dir']

directory scripts_dir do
  owner "root"
  group "root"
  mode 0755
end

package "apt-rdepends"
template "#{scripts_dir}/compute_package_size.py" do
  owner "root"
  group "root"
  mode 0755
end
