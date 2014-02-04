# This module installs node, npm, and required modules,
# apart from redis-server

class pubsub_setup($deploy_env = 'UNSET') {

  Exec { path => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ] }

  include pubsub_setup::params

  $curr_deploy_env = $deploy_env ? {
    'UNSET'   => $::pubsub_setup::params::deploy_env,
    default   => $deploy_env,
  }

  class { 'pubsub_setup::install': } ->
  class { 'pubsub_setup::config':
    deploy_env => $curr_deploy_env,
  } ~>
  class { 'pubsub_setup::service': } ->
  Class['pubsub_setup']

}
