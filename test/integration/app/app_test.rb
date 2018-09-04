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
