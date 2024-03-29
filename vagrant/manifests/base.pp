# the default path for puppet to look for executables
Exec { path => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin' ] }

stage { 'first': }

stage { 'last': }

Stage['first'] -> Stage['main'] -> Stage['last']

class update_aptget {
  exec {'apt-get update && touch /tmp/apt-get-updated':
    unless => 'test -e /tmp/apt-get-updated'
  }
}

# run apt-get update before anything else runs
class {'update_aptget':
  stage => first,
}

# change this to 'development' if you're
# mounting the app by yourself:

class { 'nodejs':
  manage_repo => true,
} ->
class { 'pubsub_setup':
  deploy_env => 'vagrant',
}
