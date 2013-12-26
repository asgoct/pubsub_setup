# install all our required packages

class pubsub_setup::install {

  package { 'git-core':
    ensure   => present,
    require  => Class['nodejs'],
  }

  package { 'build-essential':
    ensure   => present,
  }

  package { 'redis-server':
    ensure   => present,
  }

}
