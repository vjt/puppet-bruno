class bruno::libreoffice {

  # Libreoffice service
  #
  $path = '/opt/office'
  $user = 'office'
  $uid  = 302
  $gid  = 302

  $packages = [
    'libreoffice',
    'libreoffice-impress',
    'libreoffice-draw',
    'libreoffice-calc',
    'libreoffice-pyuno',
    'libreoffice-writer',
  ]

  user {$user:
    ensure  => present,
    uid     => $uid,
    gid     => $gid,
    home    => $path,
    comment => 'Libreoffice service',
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

  package {$packages:
    ensure => present,
  }

  vim::rc { $user:
    ensure => present,
    home   => $path,
  }
 
  git::rc { $user:
    ensure => present,
    home   => $path,
    group  => $gid,
    name   => 'Libreoffice',
  }

  supervise::service {'libreoffice':
    uid => $user,
    gid => $user,
  }

}
