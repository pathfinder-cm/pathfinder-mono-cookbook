#
# Cookbook:: pathfinder-mono
# Recipe:: user
#
# Copyright:: 2018, Pathfinder CM.
#
#

group node[cookbook_name]['app_group'] do
  system true
end

user node[cookbook_name]['app_user'] do
  comment "#{node[cookbook_name]['app_user']} user"
  group node[cookbook_name]['app_group']
  system true
  manage_home true
  home "/home/#{node[cookbook_name]['app_user']}"
end
