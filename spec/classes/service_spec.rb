require 'spec_helper'

describe 'pubsub_setup::service' do

  it { should contain_service('monit')
      .with({
              'ensure'      => 'running',
              'require'     => 'Package[monit]',
            })
  }

end

