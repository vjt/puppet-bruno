class bruno::interpreter {

  # Apps interpreter
  #
  $path = '/opt/ruby'
  $user = 'ruby'
  $uid  = 300
  $gid  = 300

  user {$user:
    ensure  => present,
    uid     => $uid,
    gid     => $gid,
    comment => 'Ruby apps interpreters',
    home    => $path,
    system  => true,
    shell   => '/bin/bash',
  }
  group {$user:
    ensure => present,
    gid    => $gid,
  }
  file {"${user}/home":
    path    => $path,
    ensure  => directory,
    mode    => '0755',
    owner   => $uid,
    group   => $gid,
    require => User[$user],
  }
  file {"${user}/.gemrc":
    path    => "$path/.gemrc",
    content => 'gem: --no-rdoc --no-ri',
  }

  vim::rc { $user:
    ensure => present,
    home   => $path,
  }

  git::rc { $user:
    ensure => present,
    home   => $path,
    group  => $gid,
    name   => 'Ruby',
  }

  # RBENV
  rbenv::install { $user:
    home => $path
  }

  # Ruby 1.9.3 and 1.8.7
  $rubies = {
    1.9 => '1.9.3-p194',
    1.8 => '1.8.7-p370',
  }
  rbenv::compile { [$rubies[1.8], $rubies[1.9]]:
    user => $user,
    home => $path,
  }

  if $bruno::role =~ /server/ {
    gem {['unicorn', 'thin']: ensure => present, tag => 'test'}
  }

  define gem($ensure = present) {
    rbenv::gem {"${rubies[1.8]}/${title}":
      gem    => $title,
      ensure => $ensure,
      user   => $bruno::interpreter::user,
      home   => $bruno::interpreter::path,
      ruby   => $bruno::interpreter::rubies[1.8],
    }

    rbenv::gem {"${rubies[1.9]}/${title}":
      gem    => $title,
      ensure => $ensure,
      user   => $bruno::interpreter::user,
      home   => $bruno::interpreter::path,
      ruby   => $bruno::interpreter::rubies[1.9],
    }
  }

}
