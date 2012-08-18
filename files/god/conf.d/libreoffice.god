# vim: ft=ruby

module Bruno
  module God
    def self.libreoffice(&env)
      watch(env) do |w|
        host  = '127.0.0.1'
        port  = '8100'

        w.name     = "libreoffice-service"
        w.start    = "/usr/lib64/libreoffice/program/soffice.bin --headless --accept='socket,host=#{host},port=#{port};urp;' --nofirstrunwizard"
      end
    end
  end
end
