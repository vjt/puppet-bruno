define bruno::webserver(
  $ssl_cert  = '',
  $ssl_key   = '',
  $redirects = {},
){

  class {'nginx':
    package => 'nginx-1.0',
  }

  if $ssl_cert and $ssl_key {
    nginx::cert {$title:
      crt => $ssl_cert,
      key => $ssl_key,
    }

    nginx::vhost {'default':
      prio => 00,
      port => 443,
      ssl  => true,
      apps => true,
    }

    nginx::vhost {'default-mock':
      prio => 10,
      port => 80,
      mock => 'https',
    }
  } else {
    nginx::vhost {'default':
      prio => 00,
      port => 80,
      apps => true,
    }
  }
}
