#
# Cookbook:: pathfinder-mono
# Recipe:: db_replication
#
# Copyright:: 2020, Pathfinder CM.
#
#

version = node['postgresql']['version']
env = node[cookbook_name]['env_vars']
additional_config = node['postgresql']['config']

replication_config = {
  'hot_standby' => node['postgresql']['hot_standby']
}
node.override['postgresql']['config'] = additional_config.merge(replication_config)
additional_config = node['postgresql']['config']

pathfinder_mono_pg_install "Postgresql #{version} Server Install" do
  version            version
  hba_file           node['postgresql']['hba_file']
  ident_file         node['postgresql']['ident_file']
  external_pid_file  node['postgresql']['external_pid_file']
  port               env['PROD_DB_PORT']
  action :install
end

pathfinder_mono_pg_config "Configuring Postgres Installation" do
  version               version
  data_directory        node['postgresql']['data_dir']
  hba_file              node['postgresql']['hba_file']
  ident_file            node['postgresql']['ident_file']
  external_pid_file     node['postgresql']['external_pid_file']
  stats_temp_directory  node['postgresql']['stats_temp_directory']
  additional_config     additional_config
  action :modify
end

pathfinder_mono_pg_replication "Configure Replication" do
  version                 version
  db_master_addr          node['postgresql']['db_master_addr']
  db_replication_username node['postgresql']['db_replication_username']
  db_replication_password node['postgresql']['db_replication_password']
  standby_mode            node['postgresql']['standby_mode']
  action :create
end

service "postgresql" do
  action :nothing
  supports :status => true, :start => true, :restart => true, :stop => true
end
