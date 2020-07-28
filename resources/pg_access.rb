property :version, String, required: true, default: '10'
property :accesses, Array, required: true, default: [{type: 'local', db: 'all', user: 'postgres', address: nil, method: 'ident'}]

action :grant do
  path = "/etc/postgresql/#{new_resource.version}/main/pg_hba.conf"
  with_run_context :root do
    edit_resource(:template, path) do |new_resource|
      cookbook 'pathfinder-mono'
      source 'pg_hba.conf.erb'
      owner 'postgres'
      group 'postgres'
      mode '0644'
      variables(
        accesses: new_resource.accesses
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
