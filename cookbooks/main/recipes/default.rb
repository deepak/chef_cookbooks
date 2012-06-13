#
# Cookbook Name:: main
# Recipe:: default
#
# Copyright 2012, Deepak Kannan
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# can find "installed" packages with dpkg. eg: dpkg --get-selections git
package "git"

%w( root ).each do |user|
  # it is /root not /home/root. can be any valid path
  home_path = %x{ echo ~ #{user} | cut -d ' ' -f 1 }.strip.chomp
  log("home_path is #{home_path} for user #{user}") { level :debug }

  template "#{home_path}/.gemrc" do
    source "gemrc.erb"
    owner user
    group user
  end
end

chef_gem "ruby-shadow"

user_passwords = data_bag_item 'passwords', 'user'

# rackspace has a random password. reset password to default
user "root" do
  # ubuntu 12,04 uses SHA512.
  # see /etc/login.defs ENCRYPT_METHOD is SHA512 there.
  # so command to hash password
  # > echo root:<password> | chpasswd -S -c SHA512
  # # can use "echo "username:newpass"| chpasswd" directly, but then
  # password is on the readline history
  # TODO: test that changed password works. encrypt method can
  # change. see /etc/login.defs above
  password user_passwords["root"]["password_hashed"]
end
