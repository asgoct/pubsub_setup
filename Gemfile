source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
    gem 'puppet', puppetversion, :require => false
else
    gem 'puppet', :require => false
end

gem 'capistrano', '~> 3.1.0'

group :development, :test do
  gem 'rake',                    :require => false
  gem 'rspec-puppet',            :require => false
  gem 'puppetlabs_spec_helper',  :require => false
  gem 'puppet-lint',             :require => false
  gem 'serverspec',              :require => false
  gem 'librarian-puppet',        :require => false
end
