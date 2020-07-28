#
# Cookbook:: pathfinder-mono
# Recipe:: postgresql
#
# Copyright:: 2018, Pathfinder CM.
#
#

version = node['postgresql']['version']
locale = node['postgresql']['locale']
env = node[cookbook_name]['env_vars']
additional_config = node['postgresql']['config']
accesses = []

if node['postgresql']['replication'] == true
  replication_config = {
    'wal_level' => node['postgresql']['wal_level'],
    'max_wal_senders' => node['postgresql']['max_wal_senders'],
    'archive_mode' => node['postgresql']['archive_mode'],
    'archive_command' => node['postgresql']['archive_command']
  }
  node.override['postgresql']['config'] = additional_config.merge(replication_config)
  additional_config = node['postgresql']['config']
end

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
  stats_temp_directory  node['postgresql']['stats_temp_directory']
  additional_config  additional_config
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

accesses << {
  'type' => 'host',
  'db' => env['PROD_DB_NAME'],
  'user' => env['PROD_DB_USER'],
  'address' => '0.0.0.0/0',
  'method' => 'md5'
}

if node['postgresql']['replication'] == true
  pathfinder_mono_pg_user "Creating Replication User" do
    user node['postgresql']['db_replication_username']
    password node['postgresql']['db_replication_password']
    replication true
    action :create
  end

  accesses << {
    'type' => 'host',
    'db' => 'replication',
    'user' => node['postgresql']['db_replication_username'],
    'address' => "#{node['postgresql']['db_replication_addr']}/32",
    'method' => 'trust'
  }
end

pathfinder_mono_pg_access "Configuring Access" do
  version version
  accesses accesses
end

pathfinder_mono_pg_database "Create Database" do
  database env['PROD_DB_NAME']
  user env['PROD_DB_USER']
  locale locale
end
