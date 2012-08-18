define bruno::app::server(
  $id,
  $kind,
  $scale,
  $timeout = 3600,
  $boot    = '',
  $env     = {},
) {

  $app = "${bruno::apps::root}/${title}"

  case $kind {
    unicorn : {
      file {"${app}/.unicorn.conf":
        ensure   => present,
        owner    => 'root',
        group    => $id,
        mode     => 0440,
        content  => template('bruno/unicorn.conf.erb'),
      }
    }

    thin : {
      # TODO
    }
  }

  $user  = $title
  $group = $title

  $env['RAILS_ENV'] = $bruno::env
  $env['RACK_ENV']  = $bruno::env

  supervise::app {$title:
    service => $kind,
    uid     => $user,
    gid     => $user,
    env     => $env,
  }
}
