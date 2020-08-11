app_name = node[cookbook_name]['app_name']
app_user = node[cookbook_name]['app_user']
app_group = node[cookbook_name]['app_group']
release_name = node[cookbook_name]['release_name']
app_install_dir = node[cookbook_name]['app_install_dir']
app_shared_dir = node[cookbook_name]['app_shared_dir']
log_shared_dir = node[cookbook_name]['log_shared_dir']

[
  app_install_dir,
  app_shared_dir,
  log_shared_dir,
].each do |path|
  directory path do
    owner app_user
    group app_group
    mode '0755'
    recursive true
    action :create
  end
end

git app_install_dir do
  repository node[cookbook_name]['app_repo']
  destination "#{app_install_dir}/#{release_name}"
  reference 'master'
  enable_checkout false
  user app_user
  group app_group
  action :sync
end

directory "#{app_install_dir}/#{release_name}/log" do
  recursive true
  action :delete
end

link "#{app_install_dir}/#{release_name}/log" do
  to "#{log_shared_dir}"
  action :create
  user app_user
  group app_group
end

link "#{app_install_dir}/#{app_name}"  do
  to "#{app_install_dir}/#{release_name}"
  action :create
  user app_user
  group app_group
end

# Keep only 5 latest deployments (avoid removing all other files or folders)
execute 'ls -1r | egrep \'^[[:digit:]]{10}$\' | tail -n +6 | xargs rm -rf' do
  user app_user
  group app_group
  cwd "#{app_install_dir}"
end

template "#{app_install_dir}/#{app_name}/.env" do
  source 'dotenv.erb'
  owner app_user
  group app_group
  mode 0600
  variables env_vars: node[cookbook_name]['env_vars'].sort.to_h
end

template node[cookbook_name]['env_vars_file'] do
  source 'env_vars.erb'
  owner app_user
  group app_group
  mode 0600
  variables env_vars: node[cookbook_name]['env_vars'].sort.to_h
end

template '/etc/logrotate.d/pathfinder-mono' do
  source 'logrotate/pathfinder-mono.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables directory: "#{log_shared_dir}"
end
