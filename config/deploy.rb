set :stage_dir, "config/deploy"
set :stages, Dir[ "#{ File.dirname(__FILE__) }/deploy/*.rb" ].collect { |fn| File.basename(fn, ".rb") }
set :default_stage, "staging"
require 'capistrano/ext/multistage'

require 'bundler/capistrano'

set :repository,  "git@github.com:balticit/event.git"
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
require "rvm/capistrano"

before 'deploy:assets:precompile', 'deploy:symlink_shared'
after 'deploy:restart','deploy:cleanup'

after 'deploy:symlink_shared', 'db:create'
after 'db:create', 'db:migrate'
after 'db:migrate', 'db:seed'

after 'deploy:restart', 'unicorn:restart'

desc "tail production log files"
task :tail_logs, :roles => :app do
  log_file = "#{rails_env}.log"
  run "tail -f #{File.join(shared_path, 'log', log_file)}" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

namespace :deploy do
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end

  task :symlink_robots, :roles => :app do
    run "ln -nfs #{shared_path}/config/robots.txt #{release_path}/public/robots.txt"
  end

  task :symlink_sphinx_config, :roles => :app do
    run "ln -nfs #{shared_path}/config/sphinx.yml #{release_path}/config/thinking_sphinx.yml"
  end
end

namespace :db do
  [:drop, :create, :migrate, :seed, :load_sample].each do |_task|
    task _task, :roles => :db do
      run "cd #{release_path}; RAILS_ENV=#{rails_env} #{rake} db:#{_task} --trace"
    end
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

namespace :whenever do
  task :update, :role => :app do
    run "cd #{release_path}; RAILS_ENV=#{rails_env} #{File.join(shared_path, 'scripts/rvm_wrapper.sh')} bundle exec whenever --write-crontab event"
  end
end