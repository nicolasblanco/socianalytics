# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

begin
  require 'resque/tasks'
rescue LoadError
  STDERR.puts "Resque is not enabled!"
end

Socianalytics::Application.load_tasks
