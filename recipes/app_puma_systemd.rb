app_name = node[cookbook_name]['app_name']
app_user = node[cookbook_name]['app_user']
app_group = node[cookbook_name]['app_group']
release_name = node[cookbook_name]['release_name']
app_install_dir = node[cookbook_name]['app_install_dir']
app_env = node[cookbook_name]['app_env']

template "/etc/systemd/system/puma.service" do
  source "puma_systemd.erb"
  owner app_user
  group app_group
  mode '0644'
  variables app_name: app_name,
            user: app_user,
            app_directory: "#{app_install_dir}/#{app_name}",
            puma_config_directory: "#{node[cookbook_name]['puma_config_dir']}/puma.#{app_env}.rb",
            puma_pids_directory: "#{node[cookbook_name]['puma_pids_dir']}/puma.#{app_env}.pid"
  notifies :run, "execute[systemctl-daemon-reload]", :immediately
  notifies :restart, "service[puma]", :delayed
end

execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
end

service "puma" do
  action :enable
  supports :status => true, :start => true, :restart => true, :stop => true
  provider Chef::Provider::Service::Systemd
end
