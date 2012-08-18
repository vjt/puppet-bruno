# vim: ft=ruby

module Bruno
  module God
    def self.cgit(&env)
      watch(env) do |w|
        root = w.env['HOME']
        app  = '/usr/local/sbin/fcgiwrap'
        pid  = "#{root}/.fcgi.pid"
        sock = "#{root}/.fcgi.sock"

        # Because uid switching is done by spawn-fcgi itself
        uid   = w.uid
        w.uid = 'root'

        w.pid_file = pid
        w.name     = "cgit-server"
        w.start    = "spawn-fcgi -d #{root} -s #{sock} -P #{pid} -M 0770 -u #{uid} -g #{uid} -U nginx -G nginx #{app}"
      end
    end
  end
end
