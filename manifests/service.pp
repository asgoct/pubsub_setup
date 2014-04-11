# required services

class pubsub_setup::service {

  if !defined(Service['monit']) {
    service { 'monit':
      ensure     => running,
      require    => Package['monit'],
    }
  }

}
