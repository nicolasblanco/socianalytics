# This file contains project-specific settings

# The project name
set :application, 'socianalytics'

# The projet user
set :user, 'rails'

# List the Drupal multi-site folders.  Use "default" if no multi-sites are installed
set :domains, ["default"]

# Set the repository type and location to deploy from
set :scm, 'git'
set :repository, "git@github.com:slainer68/#{application}.git"

# Use a remote cache to speed things up
# set :deploy_via, :remote_cache
set :keep_releases, 5

# Multistage support - see config/deploy/[STAGE].rb for specific configs
set :stages, %w(staging production)
set :default_stage, stages.first

# Generally don't need sudo for this deploy setup
set :use_sudo, false

require 'capistrano/ext/multistage'
require "bundler/capistrano"

def rake(*tasks)
  rails_env = fetch(:rails_env, "production")
  rake = fetch(:rake, "rake")
  tasks.each do |t|
    run "if [ -d #{release_path} ]; then cd #{release_path}; else cd #{current_path}; fi; #{rake} RAILS_ENV=#{rails_env} #{t}"
  end
end

after "deploy:update_code", "shared_config:symlinks", "resque:restart_workers"
after "deploy:setup", "config:mkdir"

namespace :config do
  desc "Create necessary directories"
  task :mkdir do
    run "mkdir  -p #{shared_path}/config"
  end
end

namespace :shared_config do
  task :symlinks do
    run "ln -nfs #{shared_path}/config/mongoid.yml #{release_path}/config/"
  end
end

namespace :resque do
  task :restart_workers, :roles => :db do
    rake "resque:restart_workers"
  end
end