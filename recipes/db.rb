#
# Cookbook:: pathfinder-mono
# Recipe:: postgresql
#
# Copyright:: 2018, Pathfinder CM.
#
#

version = node['postgresql']['version']
env = node[cookbook_name]['env_vars']

pathfinder_mono_pg_install "Postgresql #{version} Server Install" do
  version            version
  hba_file           node['postgresql']['hba_file']
  ident_file         node['postgresql']['ident_file']
  external_pid_file  node['postgresql']['external_pid_file']
  port               env['PROD_DB_PORT']
  action :install
end

pathfinder_mono_pg_config "Configuring Postgres Installation" do
  version            version
  data_directory     node['postgresql']['data_dir']
  hba_file           node['postgresql']['hba_file']
  ident_file         node['postgresql']['ident_file']
  external_pid_file  node['postgresql']['external_pid_file']
  additional_config  node['postgresql']['config']
  action :modify
end

pathfinder_mono_pg_user "Adding user to Postgres Installation" do
  user env['PROD_DB_USER']
  password env['PROD_DB_PASS']
  superuser true
  createdb true
  createrole true
  login true
  action :create
end

pathfinder_mono_pg_access "Configuring Access" do
  version version
  access_type 'host'
  access_db env['PROD_DB_NAME']
  access_user env['PROD_DB_USER']
  access_addr '*'
  access_method 'md5'
end

pathfinder_mono_pg_database "Create Database" do
  database env['PROD_DB_NAME']
  user env['PROD_DB_USER']
end

pathfinder_mono_pg_gem 'Install PG Gem' do
  client_version version
  version '1.0.0'
end
