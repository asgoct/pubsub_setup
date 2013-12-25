require 'spec_helper'

describe package('nodejs') do
  it { should be_installed }
end

describe package('git-core') do
  it { should be_installed }
end

describe port(3010) do
  it { should be_listening }
end

describe file("/home/vagrant/ln_notifications") do
  it { should be_directory }
end

describe command('cat /home/vagrant/ln_notifications/.git/config') do
  it { should return_stdout /github.com\/quippp\/ln_notifications/ }
end

