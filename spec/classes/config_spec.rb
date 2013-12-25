require 'spec_helper'

describe 'pubsub_setup::config' do
  it { should contain_class('pubsub_setup::params') }

  let(:params) { {
      :git_user => 'johndoe',
      :deploy_user => 'testuser',
      :git_pass => 'secret',
      :git_url  => 'somerepo.com',
      :app_name => 'pubsub_app',
    } }

  it { should contain_exec('git-clone-pubsub_app')
      .with({
              'command' => 'git clone https://johndoe:secret@somerepo.com/pubsub_app',
              'timeout' => '0',
              'user'    => 'testuser',
              'group'   => 'testuser',
              'cwd'     => '/home/testuser',
              'creates' => '/home/testuser/pubsub_app',
              'require' => 'Package[git-core]',
            })
  }

end
