define bruno::postgres::client {
  class { postgresql::client:
    version => $title,
  }
}

define bruno::postgres::server {
  class { postgresql::server:
    version => $title,
    listen  => $::ipaddress,

    acls    => [
      # Grant access locally with password
      'local all all md5',

      # Grant access from the server subnet with password
      "host all all ${::ipaddress}/${::cidrmask} md5"
    ],
  }
}

define bruno::postgres::db {
  $generator = $bruno::params::servicepasswd
  $password  = generate($generator, 'pgsql', $title)

  postgresql::db {$title:
    password => $password
  }
}

define bruno::postgres::config($id) {
  $app = "${bruno::apps::root}/${title}"
  $passwd = $bruno::params::servicepasswd
  $finder = $bruno::params::nodefinder

  $adapter  = 'postgresql'
  $username = $title
  $database = $title
  $password = generate($passwd, 'pgsql', $title)
  $hostname = generate($finder, 'bruno_env', $::bruno::env, 'bruno_role', 'database')
  $encoding = 'UTF8'

  file {"$app/.postgresql.yml":
    ensure  => present,
    owner   => $id,
    group   => $id,
    mode    => 0400,
    content => template('bruno/database.yml.erb'),
  }

}
