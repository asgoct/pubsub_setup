# required services

class pubsub_setup::service {

  service { 'monit':
    ensure     => running,
    require    => Package['monit'],
  }

}
