class bruno inherits bruno::params {
  $env  = $::bruno_env
  $role = $::bruno_role

  if !$env or !$role {
    fail("Please specify bruno_env and bruno_role in node params")
  }

  if $::fact_is_puppetmaster == 'true' {
    fail("Puppet masters cannot act as bruno servers")
  }

  if $role =~ /worker/ or $role =~ /server/ {
    # System interpreter
    #
    class { ::ruby: gems_version => latest }
    class { ::ruby::dev: }

    package {['gcc', 'make', 'binutils']:
      ensure => latest
    }

    package {'pry':
      ensure   => present,
      provider => 'gem',
    }

    bruno::webserver {$env:
      ssl_cert => $::bruno_crt,
      ssl_key  => $::bruno_key,
    }

    include bruno::interpreter
    include bruno::supervise
  }

  include bruno::apps

  if $role =~ /worker/ {
    include bruno::starling
    include bruno::libreoffice

    App::Core        <| |>
    App::Database    <| |>

    Postgres::Client <| |>
    Postgres::Config <| |>
  }

  if $role =~ /server/ {
    App::Core        <| |>
    App::Server      <| |>
    App::Database    <| |>

    Postgres::Client <| |>
    Postgres::Config <| |>
  }

  if $role =~ /database/ {
    App::Database    <| |>

    Postgres::Client <| |>
    Postgres::Server <| |>
    Postgres::Db     <| |>
  }

}
