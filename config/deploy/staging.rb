default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after :deploy, 'deploy:cleanup'

# be sure to change these
set :rails_env, :staging
set :user, 'rails'
role :web, 'ks363573.kimsufi.com'
role :app, 'ks363573.kimsufi.com'
role :db,  'ks363573.kimsufi.com', :primary => true

# the rest should be good
set :deploy_to, "/home/#{user}/www/#{application}"
set :branch, 'staging'
set :git_shallow_clone, 1
set :scm_verbose, true

namespace :deploy do
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :env do
  task :echo do
    run "echo printing out cap info on remote server"
    run "echo $PATH"
  end
end
