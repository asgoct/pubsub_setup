# params for pubsub

class pubsub_setup::params {
  $app_name         = 'ln_notifications'
  $deploy_user      = 'deploy'
  $git_user         = 'quippp-deployer'
  $git_pass         = 'blakb1rrd0007'
  $git_url          = 'github.com/quippp'
  $git_branch       = 'master'
  $deploy_env       = 'production'
}
