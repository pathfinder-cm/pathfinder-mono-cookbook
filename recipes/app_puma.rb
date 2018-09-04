app_name = node[cookbook_name]['app_name']
app_user = node[cookbook_name]['app_user']
app_group = node[cookbook_name]['app_group']
app_install_dir = node[cookbook_name]['app_install_dir']
puma_config_dir = node[cookbook_name]['puma_config_dir']
puma_tmp_dir = node[cookbook_name]['puma_tmp_dir']
puma_pids_dir = node[cookbook_name]['puma_pids_dir']
puma_state_dir = node[cookbook_name]['puma_state_dir']
app_env = node[cookbook_name]['app_env']

gem_package 'puma'

[puma_config_dir, puma_tmp_dir, puma_pids_dir, puma_state_dir].each do |path|
  directory path do
    owner app_user
    group app_group
    mode '0755'
    recursive true
    action :create
  end
end

template "#{puma_config_dir}/puma.#{app_env}.rb" do
  source "puma_config.rb.erb"
  owner app_user
  group app_group
  mode '0644'
  variables directory: "#{app_install_dir}/#{app_name}",
            environment: app_env,
            puma_pids_dir: puma_pids_dir,
            puma_state_dir: puma_state_dir
end

include_recipe 'pathfinder-mono::app_puma_systemd'
