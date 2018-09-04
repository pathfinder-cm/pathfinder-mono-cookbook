#
# Cookbook:: pathfinder-mono
# Attribute:: default
#
# Copyright:: 2018, Pathfinder CM.
#
#

cookbook_name = 'pathfinder-mono'
app_name = 'pathfinder-mono'

default[cookbook_name]['app_name'] = app_name
default[cookbook_name]['app_user'] = cookbook_name
default[cookbook_name]['app_group'] = cookbook_name

# App config
default[cookbook_name]['release_name'] = Time.now.strftime('%y%m%d%H%M')
default[cookbook_name]['app_install_dir'] = "/opt/#{cookbook_name}"
default[cookbook_name]['app_shared_dir'] = "#{default[cookbook_name]['app_install_dir']}/shared"
default[cookbook_name]['app_repo'] = 'https://github.com/pathfinder-cm/pathfinder-mono.git'
default[cookbook_name]['app_env'] = 'production'

# Environment variables
default[cookbook_name]['prefix_env_vars'] = '/etc/default'
default[cookbook_name]['env_vars_file'] = "#{node[cookbook_name]['prefix_env_vars']}/#{app_name}"
default[cookbook_name]['env_vars'] = {
  'RAILS_SERVE_STATIC_FILES' => true,
  'SECRET_KEY_BASE' => '123456',
  'TIMESTAMP_FORMAT' => '%d-%m-%Y %H:%M',
  'PROD_DB_HOST' => 'localhost',
  'PROD_DB_PORT' => 5432,
  'PROD_DB_NAME' => 'pathfinder-mono_production',
  'PROD_DB_POOL' => 5,
  'PROD_DB_USER' => 'pathfinder-mono',
  'PROD_DB_PASS' => '123456',
}

