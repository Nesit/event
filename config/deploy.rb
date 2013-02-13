set :stage_dir, "config/deploy"
set :stages, Dir[ "#{ File.dirname(__FILE__) }/deploy/*.rb" ].collect { |fn| File.basename(fn, ".rb") }
set :default_stage, "staging"
require 'capistrano/ext/multistage'

require 'bundler/capistrano'

set :repository,  "git@github.com:balticit/event.git"
set :scm, :git
set :application, "toonbox"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash -l'
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 10
set :asset_env, "RAILS_GROUPS=assets"
set :rvm_type, :system
require "rvm/capistrano"

before 'deploy:assets:precompile', 'deploy:symlink_shared'
after 'deploy:restart','deploy:cleanup'

after 'deploy:symlink_shared', 'db:create'
after 'db:create', 'db:migrate'
after 'db:migrate', 'db:seed'

after 'deploy:restart', 'unicorn:restart'

namespace :deploy do

  desc "Symlink shared configs and folders on each release."
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :symlink_robots, :roles => :app do
    run "ln -nfs #{shared_path}/config/robots.txt #{release_path}/public/robots.txt"
  end

end

namespace :db do
  task :drop, :roles => :db do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} #{rake} db:drop --trace"
  end

  task :create, :roles => :db do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} #{rake} db:create --trace"
  end

  task :migrate, :roles => :db do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} #{rake} db:migrate --trace"
  end

  task :seed, :roles => :db do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} #{rake} db:seed --trace"
  end

  task :load_sample, :roles => :app do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} more_samples=true bundle exec rake db:load_sample --trace"
  end
end

namespace :unicorn do
  task :stop, :roles => :app do
    run "/etc/init.d/#{application}_#{stage} stop"
  end

  task :restart, :roles => :app do
    run "/etc/init.d/#{application}_#{stage} restart"
  end
end
