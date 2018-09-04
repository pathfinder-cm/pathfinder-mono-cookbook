property :name, String, name_property: true
property :cli_opts, Array, default: []
property :unit, Hash, required: true
property :bin, String, required: true
property :env_vars_file, String
property :prefix_log, String, required: true
property :log_file_name, String, required: true

action :create do
  # Construct command line options
  options = new_resource.cli_opts.join(' ')

  # Configure systemd unit with options
  unit = new_resource.unit.to_hash

  # Create log directory
  directory "#{cookbook_name}:#{new_resource.prefix_log}" do
    path new_resource.prefix_log
    mode '0755'
    recursive true
    action :create
  end

  # Build command stack
  cmd_stack = []
  cmd_stack << new_resource.bin
  cmd_stack << options
  cmd_stack << ">> #{new_resource.prefix_log}/#{new_resource.log_file_name}"
  unit['Service']['ExecStart'] = cmd_stack.join(' ')
  unit['Service']['EnvironmentFile'] = new_resource.env_vars_file

  # Create service
  systemd_unit "#{new_resource.name}.service" do
    enabled true
    active true
    masked false
    static false
    content unit
    triggers_reload true
    action %i[create enable start]
  end
end

action :restart do
  systemd_unit "#{new_resource.name}.service" do
    action :restart
  end
end
