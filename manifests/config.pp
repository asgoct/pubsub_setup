class pubsub_setup::config(
  $deploy_user = $pubsub_setup::params::deploy_user,
  $git_user    = $pubsub_setup::params::git_user,
  $git_pass    = $pubsub_setup::params::git_pass,
  $git_url     = $pubsub_setup::params::git_url,
  $app_name    = $pubsub_setup::params::app_name,
  ) inherits pubsub_setup::params {

  exec { "git-clone-${app_name}":
    command => "git clone https://${git_user}:${git_pass}@${git_url}/${app_name}",
    timeout => 0,
    user    => $deploy_user,
    group   => $deploy_user,
    cwd     => "/home/${deploy_user}",
    creates => "/home/${deploy_user}/${app_name}",
    require => Package['git-core'],
  }

}
