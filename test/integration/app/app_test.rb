# encoding: utf-8

# Inspec test for recipe pathfinder-mono::app

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
  describe user('pathfinder-mono') do
    it { should exist }
  end

  describe group('pathfinder-mono') do
    it { should exist }
  end
end

describe package('ruby2.5 ruby2.5-dev') do
  it { should be_installed }
end

describe file('/opt/pathfinder-mono') do
  its('mode') { should cmp '0755' }
end

describe file('/opt/pathfinder-mono/shared') do
  its('mode') { should cmp '0755' }
end

describe file('/opt/pathfinder-mono/pathfinder-mono') do
  its('mode') { should cmp '0755' }
end

describe file('/etc/default/pathfinder-mono') do
  its('mode') { should cmp '0600' }
end

describe port(80) do
  it { should_not be_listening }
end

describe port(8080) do
  it { should be_listening }
end
