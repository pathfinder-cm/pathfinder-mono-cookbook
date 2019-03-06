property :database,  String, name_property: true
property :user,      String, default: 'postgres', required: true
property :encoding,  String, default: 'UTF-8'
property :locale,    String

action :create do
  createdb = 'createdb'
  createdb << " -U postgres"
  createdb << " -E #{new_resource.encoding}" if new_resource.encoding
  createdb << " -l #{new_resource.locale}" if new_resource.locale
  createdb << " -O #{new_resource.user}"
  createdb << " #{new_resource.database}"

  bash "Create Database #{new_resource.database}" do
    code createdb
    user 'postgres'
    not_if { database_exists?(new_resource.user, new_resource.database) }
  end
end

action_class do
  include PostgresqlCookbook::Helpers
end
