# A sample Gemfile
source "https://rubygems.org"

group :system_setup do
  gem "chef", "~> 10.16.2"
  gem "chefspec", "~> 0.9.0"
  gem "foodcritic", "~> 1.7.0"
  gem "berkshelf", "~> 1.1.2"
end

group :vagrant do
  gem "vagrant", "~> 1.0.5"
  gem "vagrant-list", "~> 0.0.5"
end
  
# one time setup of: vagrant box
group :master_setup do
  gem "veewee", "~> 0.3.1"
  gem "fpm", "~> 0.4.6"
end

group :deployment do
  gem "capistrano", "~> 2.14.1"
end

# berkshelf git master has some failing tests and the last release was
# broken. check after some time. managing external cookbooks manually
# for now
# Bundler could not find compatible versions for gem "thor":
#   In Gemfile:
#     berkshelf (>= 0) ruby depends on
#       thor (~> 0.15.2) ruby
#     veewee (>= 0) ruby depends on
#       thor (0.16.0)
