define bruno::app::core(
  $id,
  $ruby,
) {
  $path = "${bruno::apps::root}/${name}"

  user {$name:
    ensure  => present,
    uid     => $id,
    gid     => $id,
    comment => "${name} ruby ${ruby} application sandbox",
    home    => $path,
  }

  group {$name:
    ensure => present,
    gid    => $id
  }

  file {"${name}/home":
    ensure  => directory,
    path    => $path,
    owner   => $id,
    group   => $id,
    mode    => '0711',
    require => [ User[$name], File[$bruno::apps::root] ],
  }

  vim::rc {$name:
    ensure => present,
    home   => $path,
  }

  git::rc {$name:
    ensure => present,
    home   => $path,
    group  => $id,
    name   => "${name} App",
  }

  rbenv::client { $name:
    user => $name,
    home => $path,
    ruby => $bruno::interpreter::rubies[$ruby],
    owner  => $bruno::interpreter::user,
    source => $bruno::interpreter::path,
  }
}
