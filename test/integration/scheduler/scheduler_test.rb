# encoding: utf-8

# Inspec test for recipe pathfinder-mono::app

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe file('/etc/default/pathfinder-scheduler') do
  its('mode') { should cmp '0600' }
end
