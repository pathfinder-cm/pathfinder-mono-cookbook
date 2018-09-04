property :version, String, default: '10'
property :hba_file
property :ident_file
property :external_pid_file
property :port, [String, Integer], default: 5432

action :install do
  apt_repository 'postgresql_org_repository' do
    uri 'https://download.postgresql.org/pub/repos/apt/'
    components   ['main', new_resource.version.to_s]
    distribution "#{node['lsb']['codename']}-pgdg"
    key 'https://download.postgresql.org/pub/repos/apt/ACCC4CF8.asc'
    cache_rebuild true
  end

  package "postgresql-client-#{new_resource.version}"
  package "postgresql-#{new_resource.version}"
  find_resource(:service, 'postgresql') do
    service_name lazy { 'postgresql' }
    supports restart: true, status: true, reload: true
    action :nothing
  end
  service 'postgresql' do
    action %i[enable start]
  end
end
