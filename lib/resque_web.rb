require 'sinatra/base'
  class ResqueWeb < Sinatra::Base
    use Rack::ShowExceptions
    def call(env)
      if env["PATH_INFO"] =~ /^\/resque/
        env["PATH_INFO"].sub!(/^\/resque/, '')
        env['SCRIPT_NAME'] = '/resque'
        require 'resque/server'
        app = Resque::Server.new
       app.call(env)
     else
       super
     end
   end
end
