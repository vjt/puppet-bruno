# vim: ft=ruby

require 'pathname'

module Bruno
  module God
    extend self

    attr_reader :root

    def run(command)
      "~/bin/rbenv exec bundle exec #{command}"
    end

    def watch(environment, &service)
      ::God.watch do |w|
        w.interval = 60.seconds

        # Load the application-specific environment
        environment.call(w)

        w.env ||= {}

        # Set up user and root directory
        pw = Etc.getpwnam(w.uid.to_s)
        raise "Invalid user: #{w.uid}" unless pw
        w.env.update('HOME' => pw.dir, 'USER' => pw.name, 'LOGNAME' => pw.name)

        @root   = Pathname(pw.dir).join('current')
        @root   = @root.parent unless @root.exist?
        w.dir   = @root
        w.group = pw.name

        # Load the service-specific environment
        service.call(w)

        # determine the state on startup
        w.transition(:init, { true => :up, false => :start }) do |on|
          on.condition(:process_running) do |c|
            c.running = true
          end
        end

        # determine when process has finished starting
        w.transition([:start, :restart], :up) do |on|
          on.condition(:process_running) do |c|
            c.running = true
            c.interval = 5.seconds
          end

          # failsafe
          on.condition(:tries) do |c|
            c.times = 5
            c.transition = :start
            c.interval = 5.seconds
            c.notify = { :contacts => ['dev'], :priority => 1, :category => w.group }
          end
        end

        # start if process is not running
        w.transition(:up, :start) do |on|
          on.condition(:process_running) do |c|
            c.running = false
          end
        end

        w.transition(:up, :restart) do |on|
          # restart if memory gets too high
          on.condition(:memory_usage) do |c|
            c.above = 300.megabytes
            c.times = 2
            c.notify = { :contacts => ['dev'], :priority => 1, :category => w.group }
          end
        end

        # lifecycle
        w.lifecycle do |on|
          on.condition(:flapping) do |c|
            c.to_state = [:start, :restart]
            c.times = 5
            c.within = 5.minute
            c.transition = :unmonitored
            c.retry_in = 10.minutes
            c.retry_times = 5
            c.retry_within = 2.hours
            c.notify = { :contacts => ['dev'], :priority => 1, :category => w.group }
          end
        end
      end
    end

  end
end
