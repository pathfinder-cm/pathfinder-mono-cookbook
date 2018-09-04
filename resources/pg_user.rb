property :user, String, required: true
property :superuser, [true, false], default: false
property :createdb, [true, false], default: false
property :createrole, [true, false], default: false
property :inherit, [true, false], default: true
property :replication, [true, false], default: false
property :login, [true, false], default: true
property :password, String, required: true

action :create do
  sql = %(\\\"#{new_resource.user}\\\" WITH )
  %w(superuser createdb createrole inherit replication login).each do |perm|
    sql << "#{'NO' unless new_resource.send(perm)}#{perm.upcase} "
  end
  sql << "PASSWORD '#{new_resource.password}'"
  execute "create postgresql user #{new_resource.user}" do
    user 'postgres'
    command %(psql -c "CREATE ROLE #{sql}")
    #sensitive true
    not_if { user_exists?(new_resource.user)  }
  end
end

action_class do
  include PostgresqlCookbook::Helpers
end
