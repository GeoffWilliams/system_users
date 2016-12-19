source ENV['GEM_SOURCE'] || 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_VERSION') ? ENV['PUPPET_VERSION'] : ['>= 3.3']
gem 'metadata-json-lint'
gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 1.0.0'
gem 'puppet-lint', '>= 1.0.0'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet'
gem 'fakefs', '0.10.1', require: false
gem 'rspec', '3.5.0'
gem 'rspec-mocks', '3.5.0'
gem 'rubocop'

gem 'test-kitchen'
gem 'kitchen-puppet'
gem 'busser'
gem 'kitchen-docker'
