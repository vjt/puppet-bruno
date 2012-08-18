# vim: ft=ruby

module Bruno
  module God
    def self.thin(&env)
      watch(env) do |w|
        w.env['RAILS_RELATIVE_URL_ROOT'] ||= "/#{w.uid}"
        w.env['INSTANCE_NAME']           ||= "app"
        w.env['RACKUP_FILE']             ||= "config.ru"
        w.env['RACK_ENV']                ||= "staging"

        w.pid_file = "#{w.env['HOME']}/.thin.#{w.env['INSTANCE_NAME']}.pid"
        w.name     = "#{w.uid}-thin-#{w.env['INSTANCE_NAME']}"

        flags = [
          "-S #{w.env['HOME']}/.thin.#{w.env['INSTANCE_NAME']}.sock",
          "-R #{w.env['RACKUP_FILE']}",
          "-P #{w.pid_file}",
          "-e #{w.env['RACK_ENV']}",
          "-l log/thin.#{w.env['INSTANCE_NAME']}.log",
          "--tag #{w.uid}-#{w.env['INSTANCE_NAME']}",
          "-d"
        ].join(' ')

        w.start    = run("thin #{flags} start")
        w.stop     = run("thin #{flags} stop")
        w.restart  = run("thin #{flags} restart")

        w.behavior(:clean_pid_file)

        w.start_grace   = 10.seconds
        w.restart_grace = 10.seconds
      end
    end
  end
end
