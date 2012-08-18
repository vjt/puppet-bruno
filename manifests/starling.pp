class bruno::starling {

  # Starling queue orchestrator
  #
  $path = '/opt/starling'
  $user = 'starling'
  $uid  = 301
  $gid  = 301

  user {$user:
    ensure  => present,
    uid     => $uid,
    gid     => $gid,
    home    => $path,
    comment => 'Starling sandbox',
    system  => true,
    shell   => '/bin/bash',
  }

  group {$user:
    ensure => present,
    gid    => $gid,
  }

  file {"${user}/home":
    ensure  => directory,
    path    => $path,
    mode    => '0755',
    owner   => $uid,
    group   => $gid,
    require => User[$user],
  }

  file {"${user}/spool":
    ensure  => directory,
    path    => "${path}/spool",
    mode    => 0700,
    owner   => $uid,
    group   => $gid,
  }

  vim::rc { $user:
    ensure => present,
    home   => $path,
  }

  git::rc { $user:
    ensure => present,
    home   => $path,
    group  => $gid,
    name   => 'Starling',
  }

  rbenv::client { $user:
    user   => $user,
    home   => $path,
    ruby   => $bruno::interpreter::rubies[1.8],
    owner  => $bruno::interpreter::user,
    source => $bruno::interpreter::path,
  }

  rbenv::bundle { $user:
    user => $user,
    home => $path,
    gems => ['starling']
  }

  supervise::service {'starling':
    uid => $user,
    gid => $user,
  }

}
