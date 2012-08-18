# bRUNo - Ruby, Unicorn, Nginx on puppet

**WARNING** This is pre-release, unstable, untested code.
**Use at your own risk**

The aim of this project is to provide an heroku-like, black-box container
for ruby applications, whose infrastructure is entirely managed by puppet.

It currently supports installation of a ruby interpreter through rbenv in
a sandbox user directory; creation of per-user sandboxes for applications;
God installation as process manager; setup of systemwide services such as
starling and libreoffice; installation and management of Postgresql roles
and databases for apps, and wrapping it everything up on multiple servers.

## Concepts

Each server must define two parameters: `$bruno_env` and `$bruno_role`.
The first may contain whichever environment you like, such as `staging`
or `production`, while `role` may contain one or more of the following
tags: `server`, `worker` or `database`.

* `server` roles get nginx and application servers (`unicorn` & `thin`)
  installed and the `database.yml` configuration file generated
* `worker` roles get libreoffice, starling, and resque installed and
  the `database.yml` configuration file generated
* `database` roles get postgresql installed and configured, and get
  new users and databases created as needed.

Each deployed app defines its resources through a standard puppet `.pp`
manifest file.

## TODO

* git post-receive hook
  * on the first time ever the app is deployed, parse an app Manifest
    and then generate the `app.pp` file and manually trigger a puppet
    kick
  * on subsequent runs, then launch the buildpack and restart the app
    server of choice.

* application shell
* log viewer
* status CLI
* Tests and documentation :wink:

## Projects to build upon

* [gitolite](https://github.com/sitaramc/gitolite)
* [dokuen](http://github.com/peterkeen/dokuen)
* [buildpack-ruby](https://github.com/heroku/heroku-buildpack-ruby)

## Dependencies

* [puppet-rbenv](http://github.com/vjt/puppet-rbenv)
* [puppet-ruby](http://github.com/vjt/puppet-ruby)
* [puppet-postgresql](http://github.com/vjt/puppet-postgresql)
* [puppet-nginx](http://github.com/vjt/puppet-nginx)

## Caveats

* Tested only on Puppet Enterprise 2.5 running on OpenSuSE 11.4 (sorry)
* Requires the puppet dashboard ENC
* A role can be assigned only to a single node - you cannot have two
  "database" servers as of now

## Licensing

[BSD 2-clause](http://opensource.org/licenses/bsd-2-clause)
