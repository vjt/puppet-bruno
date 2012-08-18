# vim: ft=ruby

module Bruno
  module God
    def self.rake(&env)
      watch(env) do |w|
        task = w.env['RAKE_TASK']
        name = task.gsub(/[^\w]/, '-')

        w.name  = "#{w.uid}-rake-#{name}"
        w.log   = "#{w.dir}/log/#{name}.log"
        w.start = run("rake #{task}")
      end
    end
  end
end
