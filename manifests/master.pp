class bruno::master inherits bruno::params {
  if $::fact_is_puppetmaster == 'false' {
    fail("This class must be included on puppetmasters only")
  }

  # Service passwd tank
  $passwd = "${bruno::params::puppet}/passwd"
  file {$passwd:
    ensure => directory,
    owner  => 'pe-puppet',
    group  => 'pe-puppet',
    mode   => '0700',
  }

  # Service passwd script, requires $passwd above
  file {"${bruno::params::servicepasswd}":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('bruno/mkpasswd.sh.erb'),
  }

  # Node finder
  file {"${bruno::params::nodefinder}":
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
    source => 'puppet:///modules/bruno/nodefinder.rb',
  }
}
