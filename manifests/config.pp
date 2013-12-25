class pubsub_setup::config(
  $deploy_user = $pubsub_setup::params::deploy_user,
  $git_user    = $pubsub_setup::params::git_user,
  $git_pass    = $pubsub_setup::params::git_pass,
  $git_url     = $pubsub_setup::params::git_url,
  $git_branch  = $pubsub_setup::params::git_branch,
  $app_name    = $pubsub_setup::params::app_name,
  ) inherits pubsub_setup::params {

  exec { "git-clone-${app_name}":
    command => "git clone -b ${git_branch} https://${git_user}:${git_pass}@${git_url}/${app_name}",
    timeout => 0,
    user    => $deploy_user,
    group   => $deploy_user,
    cwd     => "/home/${deploy_user}",
    creates => "/home/${deploy_user}/${app_name}",
    require => Package['git-core'],
  }

  exec { "git-pull-${app_name}":
    user    => $deploy_user,
    group   => $deploy_user,
    timeout => 0,
    cwd     => "/home/${deploy_user}/${app_name}",
    command => 'git pull',
    require => Exec["git-clone-${app_name}"],
  }

  exec { 'npm-install':
    command     => 'npm install',
    logoutput   => true,
    timeout     => 0,
    cwd         => "/home/${deploy_user}/${app_name}",
    require     => Exec["git-clone-${app_name}"],
  }

  exec { 'copy-configjs':
    command     => 'cp config.js.sample config.js',
    user        => $deploy_user,
    group       => $deploy_user,
    cwd         => "/home/${deploy_user}/${app_name}/config",
    creates     => "/home/${deploy_user}/${app_name}/config/config.js",
    require     => Exec['npm-install'],
  }

}
