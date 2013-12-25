require 'spec_helper'

describe 'pubsub_setup::config' do
  it { should contain_class('pubsub_setup::params') }

  let(:params) { {
      :git_user => 'johndoe',
      :deploy_user => 'testuser',
      :git_pass => 'secret',
      :git_url  => 'somerepo.com',
      :app_name => 'pubsub_app',
      :git_branch => 'my_br',
    } }

  it { should contain_exec('git-clone-pubsub_app')
      .with({
              'command' => 'git clone -b my_br https://johndoe:secret@somerepo.com/pubsub_app',
              'timeout' => '0',
              'user'    => 'testuser',
              'group'   => 'testuser',
              'cwd'     => '/home/testuser',
              'creates' => '/home/testuser/pubsub_app',
              'require' => 'Package[git-core]',
            })
  }

  it { should contain_exec('git-pull-pubsub_app')
      .with({
              'user'    => 'testuser',
              'group'   => 'testuser',
              'timeout' => '0',
              'cwd'     => '/home/testuser/pubsub_app',
              'command' => 'git pull',
              'require' => 'Exec[git-clone-pubsub_app]',
            })
  }

  it { should contain_exec('npm-install')
      .with({
              'command'   => 'npm install',
              'logoutput' => 'true',
              'timeout'   => '0',
              'cwd'       => '/home/testuser/pubsub_app',
              'require'   => 'Exec[git-clone-pubsub_app]',
            })
  }

  it { should contain_exec('copy-configjs')
      .with({
              'command'   => 'cp config.js.sample config.js',
              'user'      => 'testuser',
              'group'     => 'testuser',
              'cwd'       => '/home/testuser/pubsub_app/config',
              'creates'   => '/home/testuser/pubsub_app/config/config.js',
              'require'   => 'Exec[npm-install]',
            })
  }

  it { should contain_exec('start-server-pubsub_app')
      .with({
              'command'   => 'node app.js&',
              'user'      => 'testuser',
              'group'     => 'testuser',
              'cwd'       => '/home/testuser/pubsub_app',
              'unless'    => "ps ax | grep '[n]ode app.js'",
              'require'   => 'Exec[copy-configjs]',
            })
  }

end
