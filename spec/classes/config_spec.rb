require 'spec_helper'

describe 'pubsub_setup::config' do
  it { should contain_class('pubsub_setup::params') }

  context 'when deploy_env is vagrant' do

    let(:params) { {
        :git_user => 'johndoe',
        :deploy_user => 'testuser',
        :deploy_env  => 'vagrant',
        :git_pass => 'secret',
        :git_url  => 'somerepo.com',
        :app_name => 'pubsub_app',
        :git_branch => 'my_br',
      } }

    it { should contain_file('/etc/monit/monitrc')
        .with({
                'ensure'     => 'file',
                'source'     => 'puppet:///modules/pubsub_setup/monitrc',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/monit/conf.d/pubsub.conf')
        .with({
                'ensure'     => 'file',
                'require'    => 'template(pubsub_setup/monit_pubsub.conf.erb)',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/monit/conf.d/pubsub.conf')
        .with_content(/check process pubsub with pidfile \/var\/run\/pubsub.pid/)
        .with_content(/group pubsub/)
        .with_content(/start program = \"\/etc\/init.d\/pubsub start\"/)
        .with_content(/stop program = \"\/etc\/init.d\/pubsub stop\"/)
    }

    it { should contain_file('/etc/init.d/pubsub')
        .with({
                'ensure'     => 'file',
                'require'    => 'template(pubsub_setup/init_pubsub.conf.erb)',
                'mode'       => '0755',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/init.d/pubsub')
        .with_content(/PID_FILE=\/var\/run\/pubsub.pid/)
        .with_content(/LOG_FILE=\/home\/testuser\/pubsub_app\/log\/node.log/)
        .with_content(/--exec \/bin\/bash -- -c \"cd \/home\/testuser\/pubsub_app; exec node app.js > \$LOG_FILE 2>&1\"/)
    }

    it { should contain_user('testuser')
        .with({ 'ensure'     => 'present',
                'managehome' => 'true',
                'shell'      => '/bin/bash',
                'password'   => '$1$Zn4UIQ5U$oh4IqMnvkRuqYZQbdXJl91',
              })
    }

    it { should contain_exec('git-clone-pubsub_app')
        .with({
                'command' => 'git clone -b my_br https://johndoe:secret@somerepo.com/pubsub_app',
                'timeout' => '0',
                'user'    => 'testuser',
                'group'   => 'testuser',
                'cwd'     => '/home/testuser',
                'creates' => '/home/testuser/pubsub_app',
                'require' => ['Package[git-core]', 'User[testuser]'],
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
                'require'   => ['Exec[git-pull-pubsub_app]', 'Package[nodejs]'],
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

  context 'development setting' do

    let(:params) { {
        :git_user => 'johndoe',
        :deploy_user => 'testuser',
        :git_pass => 'secret',
        :git_url  => 'somerepo.com',
        :app_name => 'pubsub_app',
        :git_branch => 'my_br',
        :deploy_env => 'development',
      } }

    it { should contain_file('/etc/monit/monitrc')
        .with({
                'ensure'     => 'file',
                'source'     => 'puppet:///modules/pubsub_setup/monitrc',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/monit/conf.d/pubsub.conf')
        .with({
                'ensure'     => 'file',
                'require'    => 'template(pubsub_setup/monit_pubsub.conf.erb)',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/monit/conf.d/pubsub.conf')
        .with_content(/check process pubsub with pidfile \/var\/run\/pubsub.pid/)
        .with_content(/group pubsub/)
        .with_content(/start program = \"\/etc\/init.d\/pubsub start\"/)
        .with_content(/stop program = \"\/etc\/init.d\/pubsub stop\"/)
    }

    it { should contain_file('/etc/init.d/pubsub')
        .with({
                'ensure'     => 'file',
                'mode'       => '0755',
                'require'    => 'template(pubsub_setup/init_pubsub.conf.erb)',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/init.d/pubsub')
        .with_content(/PID_FILE=\/var\/run\/pubsub.pid/)
        .with_content(/LOG_FILE=\/home\/testuser\/pubsub_app\/log\/node.log/)
        .with_content(/--exec \/bin\/bash -- -c \"cd \/home\/testuser\/pubsub_app; exec node app.js > \$LOG_FILE 2>&1\"/)
    }

    it { should contain_user('testuser')
        .with({ 'ensure'     => 'present',
                'managehome' => 'true',
                'shell'      => '/bin/bash',
                'password'   => '$1$Zn4UIQ5U$oh4IqMnvkRuqYZQbdXJl91',
              })
    }

    it { should_not contain_exec('git-clone-pubsub_app') }
    it { should_not contain_exec('git-pull-pubsub_app') }

    it { should contain_exec('npm-install')
        .with({
                'command'   => 'npm install',
                'logoutput' => 'true',
                'timeout'   => '0',
                'cwd'       => '/home/testuser/pubsub_app',
                'require'   => ['Package[nodejs]', 'User[testuser]'],
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

  context 'production setting' do

    let(:params) { {
        :deploy_user => 'testuser',
        :deploy_env => 'production',
      } }

    it { should contain_file('/etc/monit/monitrc')
        .with({
                'ensure'     => 'file',
                'source'     => 'puppet:///modules/pubsub_setup/monitrc',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/monit/conf.d/pubsub.conf')
        .with({
                'ensure'     => 'file',
                'require'    => 'template(pubsub_setup/monit_pubsub.conf.erb)',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/monit/conf.d/pubsub.conf')
        .with_content(/check process pubsub with pidfile \/var\/run\/pubsub.pid/)
        .with_content(/group pubsub/)
        .with_content(/start program = \"\/etc\/init.d\/pubsub start\"/)
        .with_content(/stop program = \"\/etc\/init.d\/pubsub stop\"/)
    }

    it { should contain_file('/etc/init.d/pubsub')
        .with({
                'ensure'     => 'file',
                'mode'       => '0755',
                'require'    => 'template(pubsub_setup/init_pubsub.conf.erb)',
                'require'    => 'Package[monit]',
                'notify'     => 'Service[monit]',
              })
    }

    it { should contain_file('/etc/init.d/pubsub')
        .with_content(/PID_FILE=\/var\/run\/pubsub.pid/)
        .with_content(/LOG_FILE=\/home\/testuser\/ln_notifications\/current\/log\/node.log/)
        .with_content(/--exec \/bin\/bash -- -c \"cd \/home\/testuser\/ln_notifications\/current; exec node app.js > \$LOG_FILE 2>&1\"/)
    }

    it { should contain_user('testuser')
        .with({ 'ensure'     => 'present',
                'managehome' => 'true',
                'shell'      => '/bin/bash',
                'password'   => '$1$Zn4UIQ5U$oh4IqMnvkRuqYZQbdXJl91',
              })
    }

    it { should_not contain_exec('git-clone-pubsub_app') }
    it { should_not contain_exec('git-pull-pubsub_app') }

    it { should_not contain_exec('npm-install') }

    it { should_not contain_exec('copy-configjs') }

    it { should_not contain_exec('start-server-pubsub_app') }

   end
end
