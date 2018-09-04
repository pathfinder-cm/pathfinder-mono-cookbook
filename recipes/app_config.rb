app_name = node[cookbook_name]['app_name']
app_user = node[cookbook_name]['app_user']
app_group = node[cookbook_name]['app_group']
release_name = node[cookbook_name]['release_name']
app_install_dir = node[cookbook_name]['app_install_dir']
app_shared_dir = node[cookbook_name]['app_shared_dir']

[
  app_install_dir,
  app_shared_dir,
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

link "#{app_install_dir}/#{app_name}"  do
  to "#{app_install_dir}/#{release_name}"
  action :create
  user app_user
  group app_group
end

template node[cookbook_name]['env_vars_file'] do
  source 'env_vars.erb'
  owner app_user
  group app_group
  mode 0600
  variables env_vars: node[cookbook_name]['env_vars'].sort.to_h
end
