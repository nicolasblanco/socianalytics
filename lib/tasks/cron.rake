desc "This task is called by the Heroku cron add-on"
task :cron => :environment do
  User.compute_data
end
