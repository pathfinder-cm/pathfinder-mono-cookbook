property :version, String
property :data_directory, String
property :hba_file, String
property :ident_file, String
property :external_pid_file, String
property :additional_config, Hash, default: {}
property :cookbook, String

action :modify do
  path = "/etc/postgresql/#{new_resource.version}/main/postgresql.conf"
  template path do
    cookbook new_resource.cookbook
    source 'postgresql.conf.erb'
    owner 'postgres'
    group 'postgres'
    mode '0600'
    variables(
      data_dir: new_resource.data_directory,
      hba_file: new_resource.hba_file,
      ident_file: new_resource.ident_file,
      external_pid_file: new_resource.external_pid_file,
      additional_config: new_resource.additional_config
    )
  end
end
