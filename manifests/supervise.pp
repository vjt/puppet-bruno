class bruno::supervise {
  $rootdir = '/etc/god'
  $confdir = "${rootdir}/conf.d"
  $appsdir = "${rootdir}/apps.d"
  $servdir = "${rootdir}/services.d"

  $env  = $bruno::env
  $role = $bruno::role

  package {'god':
    ensure   => latest,
    provider => 'gem',
    require  => Package['ruby', 'gcc', 'make'],
  }

  file {$rootdir:
    ensure => directory,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }

  file {"${rootdir}/config":
    ensure  => present,
    content => template('bruno/god/config.erb'),
  }

  file {$confdir:
    ensure  => directory,
    recurse => true,
    purge   => true,
    source  => 'puppet:///modules/bruno/god/conf.d',
    notify  => Service['god'],
  }

  file {"${confdir}/contacts.god":
    ensure  => present,
    mode    => '0644',
    content => template('bruno/god/contacts.god.erb'),
  }

  file {'/etc/init.d/god':
    ensure => present,
    mode   => '0755',
    source => 'puppet:///modules/bruno/god/god.init',
  }

  service {'god':
    ensure  => running,
    enable  => true,
    require => File['/etc/init.d/god'],
  }

  file {[$servdir, $appsdir]:
    ensure => directory,
    mode   => '0700',
  }

  define service($uid, $gid, $env = {}) {
    $service = $title # Used in the template

    file {"${bruno::supervise::servdir}/${title}.god":
      ensure  => present,
      content => template('bruno/god/service.erb'),
      notify  => Service['god'],
    }
  }

  define app($uid, $gid, $service, $env = {}) {
    file {"${bruno::supervise::appsdir}/${title}.god":
      ensure  => present,
      content => template('bruno/god/service.erb'),
      notify  => Service['god'],
    }
  }

}
