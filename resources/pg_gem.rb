property :client_version, String, default: '10'
# gem options
property :version, [String, nil], default: '0.21.0'
property :clear_sources, [true, false]
property :include_default_source, [true, false]
property :gem_binary, String
property :options, [String, Hash]
property :timeout, Integer, default: 300
property :source, String

action :install do
  package %W[
    libpq5 libpq-dev postgresql-client-#{new_resource.client_version}
    libgmp-dev postgresql-#{new_resource.client_version}
  ]
  build_essential 'essentially essential' do
    compile_time true
  end
  gem_package 'pg' do
    clear_sources new_resource.clear_sources if new_resource.clear_sources
    include_default_source new_resource.include_default_source if new_resource.include_default_source
    gem_binary new_resource.gem_binary if new_resource.gem_binary
    options new_resource.options if new_resource.options
    source new_resource.source if new_resource.source
    timeout new_resource.timeout if new_resource.timeout
    version new_resource.version if new_resource.version
    action :install
  end
end
