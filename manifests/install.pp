# install all our required packages

class pubsub_setup::install {

  package { 'git-core':
    ensure   => present,
  }

}
