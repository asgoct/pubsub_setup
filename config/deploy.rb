# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'pubsub_setup'
set :repo_url, 'git@github.com:quippp/pubsub_setup.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/home/deploy/pubsub_setup'

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :keep_releases, 5

namespace :deploy do

  desc 'Link the module'
  task :link_modules do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd /home/deploy/modules && rm -f pubsub_setup && ln -s #{release_path} pubsub_setup"
      execute "cd #{release_path}/vagrant && librarian-puppet install --path /home/deploy/modules"
    end
  end

  after :publishing, :link_modules

end
