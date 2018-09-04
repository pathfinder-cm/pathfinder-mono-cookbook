property :version, String, required: true, default: '10'
property :access_type,   String, required: true, default: 'local'
property :access_db,     String, required: true, default: 'all'
property :access_user,   String, required: true, default: 'postgres'
property :access_addr,   [String, nil], default: nil
property :access_method, String, required: true, default: 'ident'

action :grant do
  path = "/etc/postgresql/#{new_resource.version}/main/pg_hba.conf"
  with_run_context :root do
    edit_resource(:template, path) do |new_resource|
      source 'pg_hba.conf.erb'
      owner 'postgres'
      group 'postgres'
      mode '0600'
      variables(
        comment: "#{new_resource.access_user} access",
        type: new_resource.access_type,
        db: new_resource.access_db,
        user: new_resource.access_user,
        address: new_resource.access_addr,
        method: new_resource.access_method
      )
      action :nothing
      delayed_action :create
      notifies :trigger, new_resource, :immediately
    end
  end
end

action :trigger do
  new_resource.updated_by_last_action(true) # ~FC085
end
