# vim: ft=ruby

module Bruno
  module God
    def self.unicorn(&env)
      watch(env) do |w|
        home = w.env['HOME']

        w.env['RAILS_RELATIVE_URL_ROOT'] ||= "/#{w.uid}"

        w.pid_file = "#{home}/.unicorn.pid"
        w.name     = "#{w.uid}-unicorn"
        w.start    = run("unicorn -c #{home}/.unicorn.conf -E #{w.env['RAILS_ENV']} -D")
        w.stop     = "kill -QUIT `cat #{w.pid_file}`"
        w.restart  = "kill -USR2 `cat #{w.pid_file}`"

        w.behavior(:clean_pid_file)

        w.start_grace   = 10.seconds
        w.restart_grace = 10.seconds
      end
    end
  end
end
