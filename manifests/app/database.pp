define bruno::app::database(
  $id,
  $kind,
) {

  case $kind {
    postgres: {
      $version = '9.0'

      # Software
      @bruno::postgres::client {$version: tag => 'test'}
      @bruno::postgres::server {$version: tag => 'test'}

      # Database
      @bruno::postgres::db {$title: tag => 'test' }

      # App config
      @bruno::postgres::config {$title: id => $id, tag => 'test'}
    }

    redis: {
      # TODO
    }

    mongodb: {
      # TODO
    }

    mysql: {
      # TODO
    }
  }
}
