# encoding: utf-8

# Inspec test for recipe pathfinder-mono::db

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe package('postgresql-10 postgresql-client-10') do
  it { should be_installed }
end

describe port(5432) do
  it { should be_listening }
end
