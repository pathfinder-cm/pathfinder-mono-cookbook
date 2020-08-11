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
default[cookbook_name]['log_shared_dir'] = "#{default[cookbook_name]['app_install_dir']}/shared/log"
default[cookbook_name]['app_repo'] = 'https://github.com/pathfinder-cm/pathfinder-mono.git'
default[cookbook_name]['app_env'] = 'production'

# Environment variables
default[cookbook_name]['prefix_env_vars'] = '/etc/default'
default[cookbook_name]['env_vars_file'] = "#{default[cookbook_name]['prefix_env_vars']}/#{app_name}"
default[cookbook_name]['env_vars'] = {
  'RAILS_ENV' => default[cookbook_name]['app_env'],
  'RAILS_SERVE_STATIC_FILES' => true,
  'RAILS_USE_MASTER_KEY' => false,
  'RAILS_MASTER_KEY' => '',
  'SECRET_KEY_BASE' => '123456',
  'TIMESTAMP_FORMAT' => '%d-%m-%Y %H:%M',
  'PROD_DB_HOST' => 'localhost',
  'PROD_DB_PORT' => 5432,
  'PROD_DB_NAME' => 'pathfinder_mono_production',
  'PROD_DB_POOL' => 5,
  'PROD_DB_USER' => 'pathfinder-mono',
  'PROD_DB_PASS' => '123456',
  'SCHEDULER_TYPE' => 'CONTAINER_NUM',
  'SCHEDULER_MEMORY_THRESHOLD' => 80,
}

# PostgreSQL config
pg_version = '10'
default['postgresql']['version'] = pg_version
default['postgresql']['config_dir'] = "/etc/postgresql/#{pg_version}/main"
default['postgresql']['data_dir'] = "/var/lib/postgresql/#{pg_version}/main"
default['postgresql']['external_pid_file'] = "/var/run/postgresql/#{pg_version}-main.pid"
default['postgresql']['stats_temp_directory'] = "/var/lib/postgresql/#{node['postgresql']['version']}/main/pg_stat_tmp"
default['postgresql']['hba_file'] = "#{node['postgresql']['config_dir']}/pg_hba.conf"
default['postgresql']['ident_file'] = "#{node['postgresql']['config_dir']}/pg_ident.conf"
default['postgresql']['locale'] = 'C.UTF-8'

default['postgresql']['config'] = {
  'listen_addresses' => '*',
  'timezone' => 'Asia/Jakarta',
  'log_timezone' => 'Asia/Jakarta',
  'dynamic_shared_memory_type' => 'posix',
  'log_line_prefix' => '%t [%p]: [%l-1] user=%u,db=%d,app=%a,client=%h ',
  'track_counts' => 'on',
  'max_connections' => 1000
}

## Replication config
default['postgresql']['replication']                  = false
default['postgresql']['db_master_addr']               = '10.0.10.10'
default['postgresql']['db_replication_addr']          = '10.0.10.11'
default['postgresql']['db_replication_username']      = 'replication_user'
default['postgresql']['db_replication_password']      = 'password1234'
default['postgresql']['wal_level']                    = 'hot_standby'
default['postgresql']['archive_mode']                 = 'on'
default['postgresql']['archive_command']              = 'cd .'
default['postgresql']['max_wal_senders']              = '8'
default['postgresql']['hot_standby']                  = 'on'


# Puma config
default[cookbook_name]['puma_dir'] = "#{default[cookbook_name]['app_install_dir']}/shared/puma"
default[cookbook_name]['puma_config_dir'] = "#{default[cookbook_name]['puma_dir']}/config"
default[cookbook_name]['puma_tmp_dir'] = "#{default[cookbook_name]['puma_dir']}/tmp"
default[cookbook_name]['puma_pids_dir'] = "#{default[cookbook_name]['puma_tmp_dir']}/pids"
default[cookbook_name]['puma_state_dir'] = "#{default[cookbook_name]['puma_tmp_dir']}/state"

# Scheduler config
default[cookbook_name]['scheduler']['cli_opts'] = []
default[cookbook_name]['scheduler']['env_vars_file'] = "#{default[cookbook_name]['prefix_env_vars']}/pathfinder-scheduler"
default[cookbook_name]['scheduler']['prefix_log'] = '/var/log/pathfinder-scheduler'
default[cookbook_name]['scheduler']['log_file_name'] = 'scheduler.log'
default[cookbook_name]['scheduler']['systemd_unit'] = {
  'Unit' => {
    'Description' => 'Pathfinder Scheduler',
    'After' => 'network.target'
  },
  'Service' => {
    'Type' => 'simple',
    'User' => default[cookbook_name]['app_user'],
    'Group' => default[cookbook_name]['app_group'],
    'Restart' => 'on-failure',
    'RestartSec' => 2,
    'StartLimitInterval' => 50,
    'StartLimitBurst' => 10,
    'ExecStart' => 'TO_BE_COMPLETED',
    'WorkingDirectory' => "#{default[cookbook_name]['app_install_dir']}/#{app_name}"
  },
  'Install' => {
    'WantedBy' => 'multi-user.target'
  }
}
