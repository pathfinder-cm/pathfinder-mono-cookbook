include Chef::Mixin::ShellOut
module PostgresqlCookbook
  module Helpers
    def execute_sql(query, db_name)
      statement = query.is_a?(String) ? query : query.join("\n")
      cmd = shell_out("psql -q --tuples-only --no-align -d #{db_name} -f -", user: 'postgres', input: statement)
      if cmd.exitstatus == 0 && !cmd.stderr.empty?
        Chef::Log.fatal("psql failed executing this SQL statement:\n#{statement}")
        Chef::Log.fatal(cmd.stderr)
        raise 'SQL ERROR'
      end
      cmd.stdout.chomp
    end

    def database_exists?(user, database)
      sql = %(SELECT datname from pg_database WHERE datname='#{database}')
      exists = %(psql -c "#{sql}")
      exists << " -U #{user}"
      exists << " | grep #{database}"
      cmd = Mixlib::ShellOut.new(exists, user: 'postgres')
      cmd.run_command
      cmd.exitstatus == 0
    end

    def user_exists?(user)
      exists = %(psql -c "SELECT rolname FROM pg_roles WHERE rolname='#{user}'" | grep '#{user}')
      cmd = Mixlib::ShellOut.new(exists, user: 'postgres')
      cmd.run_command
      cmd.exitstatus == 0
    end

    def extension_installed?
      query = "SELECT 'installed' FROM pg_extension WHERE extname = '#{new_resource.extension}';"
      !(execute_sql(query, new_resource.database) =~ /^installed$/).nil?
    end
  end
end
