# install all our required packages

class pubsub_setup::install {

  package { 'redis-server':
    ensure   => present,
  }

}
