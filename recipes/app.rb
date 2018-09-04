#
# Cookbook:: pathfinder-mono
# Recipe:: app
#
# Copyright:: 2018, Pathfinder CM.
#
#

include_recipe 'pathfinder-mono::app_user'
include_recipe 'pathfinder-mono::app_install'
include_recipe 'pathfinder-mono::app_config'
include_recipe 'pathfinder-mono::app_rails'
