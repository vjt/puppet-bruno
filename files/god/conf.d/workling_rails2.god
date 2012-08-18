# vim: ft=ruby

module Bruno
  module God
    def self.workling_rails2(&env)
      watch(env) do |w|
        w.pid_file = "#{root}/log/workling.pid"
        w.name     = "#{w.uid}-workling"
        w.start    = run("./script/workling_client start")
        w.stop     = run("./script/workling_client stop")
        w.restart  = run("./script/workling_client restart")

        w.behavior(:clean_pid_file)

        w.start_grace   = 5.seconds
        w.restart_grace = 5.seconds
      end
    end
  end
end
