#
# Cookbook:: pathfinder-mono
# Recipe:: scheduler
#
# Copyright:: 2018, Pathfinder CM.
#
#

app_name = node[cookbook_name]['app_name']
app_user = node[cookbook_name]['app_user']
app_group = node[cookbook_name]['app_group']
app_install_dir = node[cookbook_name]['app_install_dir']
bin = "#{app_install_dir}/#{app_name}/bin/rake scheduler:start"

template node[cookbook_name]['scheduler']['env_vars_file'] do
  source 'env_vars.erb'
  owner app_user
  group app_group
  mode 0600
  variables env_vars: node[cookbook_name]['env_vars'].sort.to_h
end

pathfinder_mono_binary_systemd 'pathfinder-scheduler' do
  cli_opts node[cookbook_name]['scheduler']['cli_opts']
  unit node[cookbook_name]['scheduler']['systemd_unit']
  bin bin
  env_vars_file node[cookbook_name]['scheduler']['env_vars_file']
  prefix_log node[cookbook_name]['scheduler']['prefix_log']
  log_file_name node[cookbook_name]['scheduler']['log_file_name']
end

systemd_unit "pathfinder-scheduler.service" do
  action :restart
end
