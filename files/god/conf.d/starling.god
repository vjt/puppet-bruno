# vim: ft=ruby

module Bruno
  module God
    def self.starling(&env)
      watch(env) do |w|
        home  = w.env['HOME']
        pid   = "#{home}/.starling.pid"
        log   = "#{home}/starling.log"
        spool = "#{home}/spool"
        host  = '127.0.0.1'
        port  = '22122'

        w.pid_file = pid
        w.name     = "#{w.uid}-daemon"
        w.start    = run("starling -d -h #{host} -p #{port} -q #{spool} -P #{pid} -L #{log}")
        w.stop     = "kill `cat #{pid}`"

        w.behavior(:clean_pid_file)
      end
    end
  end
end
