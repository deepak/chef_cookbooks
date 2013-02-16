require 'rspec'
require 'rspec/core/rake_task'
require 'foodcritic'

desc "Run all examples"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'cookbooks/*/spec/*_spec.rb'
  t.rspec_opts = %w[--color]
end

task :default => [:spec]

task :default => [:foodcritic]
FoodCritic::Rake::LintTask.new do |t|
  t.files = 'cookbooks'
end

# uninstall all gems
# gem list | cut -d" " -f1 | xargs gem uninstall -aIx

# TODO: extract TODO snippets from ./cookbooks
