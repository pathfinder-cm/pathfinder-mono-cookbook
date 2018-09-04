app_name = node[cookbook_name]['app_name']
app_user = node[cookbook_name]['app_user']
app_env = node[cookbook_name]['app_env']
app_install_dir = node[cookbook_name]['app_install_dir']
app_shared_dir = node[cookbook_name]['app_shared_dir']

execute 'run bundle install' do
  user app_user
  command "bundle install --path #{app_shared_dir}/.local --without development:test"
  cwd "#{app_install_dir}/#{app_name}"
end

execute 'setup database' do
  user app_user
  command "
    RAILS_ENV=#{app_env} bin/rake db:migrate && \
    RAILS_ENV=#{app_env} bin/rake assets:precompile
  "
  cwd "#{app_install_dir}/#{app_name}"
end

service 'puma' do
  subscribes :restart, 'execute[setup database]', :delayed
end
