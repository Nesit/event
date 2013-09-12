require 'bundler/capistrano'
set :stage_dir, "config/deploy"
set :stages, Dir[ "#{ File.dirname(__FILE__) }/deploy/*.rb" ].collect { |fn| File.basename(fn, ".rb") }
set :default_stage, "staging"
require 'capistrano/ext/multistage'
require 'capistrano-helpers/privates'

set :repository,  "git@github.com:Nesit/event.git"
set :scm, :git
set :application, "event"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
default_run_options[:shell] = '/bin/bash -l'
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 10
set :asset_env, "RAILS_GROUPS=assets"
set :rvm_type, :system
set :base_directory, '/var/www/apps'

set :privates, %w{
  config/database.yml
}

before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'

after 'deploy:restart', 'unicorn:restart'  # app preloaded

after 'deploy:restart', 'nginx:update_site_config'
after 'nginx:update_site_config', 'nginx:reload'

after 'deploy:restart', 'deploy:cleanup' #remove old releases

require "rvm/capistrano"
require 'capistrano-unicorn'

desc "tail production log files"
task :tail_logs, :roles => :app do
  log_file = "#{rails_env}.log"
  run "tail -f #{File.join(shared_path, 'log', log_file)}" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end


namespace :db do
  [:drop, :create, :migrate, :seed, :load_sample].each do |_task|
    task _task, :roles => :db do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} #{rake} db:#{_task} --trace"
    end
  end
end

namespace :sphinx do
  [:configure, :index, :start, :stop, :rebuild].each do |_task|
    task _task, :roles => :db do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} #{rake} ts:#{_task} --trace"
    end
  end
end

namespace :weather do
  task :update, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} #{rake} weather:update --trace"
  end
end

Dir.glob('config/deploy/shared/*.rb').each{ |file| load file }