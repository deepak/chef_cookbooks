require 'chefspec'

describe 'nginx::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge 'nginx::default' }

  it 'should install nginx' do
    chef_run.should install_package 'nginx'
  end

  it 'should create nginx config file' do
    chef_run.should create_file "/etc/nginx/nginx.conf"
  end

  it 'should initialize and start services' do
    chef_run.should start_service 'nginx'
    chef_run.should set_service_to_start_on_boot 'nginx'
  end
  
end
