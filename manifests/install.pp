# install all our required packages

class pubsub_setup::install {

  package { 'redis-server':
    ensure   => present,
  }

  if !defined(Package['nodejs']) {
    package { 'nodejs':
      ensure   => present,
    }
  }

  if !defined(Package['git-core']) {
    package { 'git-core':
      ensure   => present,
    }
  }

}
