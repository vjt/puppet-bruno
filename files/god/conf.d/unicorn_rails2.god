# vim: ft=ruby

module Bruno
  module God
    def self.unicorn_rails2(&env)
      watch(env) do |w|
        mount_at = w.env['RAILS_RELATIVE_URL_ROOT'] || "/#{w.uid}"

        if mount_at.empty?
          mount_at = w.env['RAILS_RELATIVE_URL_ROOT'] = nil
        else
          mount_at = "--path #{mount_at}"
        end

        w.pid_file = "#{w.env['HOME']}/.unicorn.pid"
        w.name     = "#{w.uid}-unicorn"
        w.start    = run("unicorn_rails -c config/unicorn.conf.rb -E #{w.env['RAILS_ENV']} -D #{mount_at}")
        w.stop     = "kill -QUIT `cat #{w.pid_file}`"
        w.restart  = "kill -USR2 `cat #{w.pid_file}`"

        w.behavior(:clean_pid_file)

        w.start_grace   = 10.seconds
        w.restart_grace = 10.seconds
      end
    end
  end
end
