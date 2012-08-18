class bruno::apps {

  $id   = 5001
  $ruby = '1.8'
  $app  = 'prot'

  @app::core {$app:
    id   => $id,
    ruby => $ruby,
    tag  => 'test',
  }

  @app::server {$app:
    id    => $id,
    kind  => 'unicorn',
    scale => '4',
    boot  => 'puts "test"',
    tag   => 'test',
  }

  @app::database {$app:
    id   => $id,
    kind => 'postgres',
    tag  => 'test',
  }

}
