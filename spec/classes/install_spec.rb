require 'spec_helper'

describe 'pubsub_setup::install' do
  it { should contain_package('build-essential')
      .with({
              'ensure' => 'present',
            })
  }

  it { should contain_package('redis-server')
      .with({
              'ensure' => 'present',
            })
  }

  it { should contain_package('git-core')
      .with({
              'ensure' => 'present',
            })
  }

  it { should contain_package('nodejs')
      .with({
              'ensure' => 'present',
            })
  }

  it { should contain_package('monit')
      .with({
              'ensure' => 'present',
            })
  }

end
