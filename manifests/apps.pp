class bruno::apps {

  import 'apps/*.pp'

  $root = '/opt/rails'

  file {$root:
    ensure => directory,
    mode   => 0755,
  }

}
