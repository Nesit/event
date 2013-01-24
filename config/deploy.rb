require 'bundler/capistrano'

set :stages, %w(production)
set :default_stage, "production"
set :repository,  "git@github.com:balticit/event.git"
set :scm, :git
set :application, "event"
ssh_options[:forward_agent] = true
default_run_options[:pty] = true

role :web, "stage.event.elzar.srv.balticit.ru"
role :app, "stage.event.elzar.srv.balticit.ru"
role :db,  "stage.event.elzar.srv.balticit.ru", :primary => true

set :user, 'rvm_user'
set :deploy_via, :remote_cache
set :use_sudo, false

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-1.9.3-p194'
require "rvm/capistrano"

set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"
set :branch, "master"
set :keep_releases, 10

after 'deploy:restart','deploy:cleanup'
before 'deploy:finalize_update', 'shared:symlinks'

after 'shared:symlinks', 'db:create'
after 'db:create', 'deploy:migrate'
before 'unicorn:reload', 'unicorn:stop'

if ENV['cleanup_release']
  before 'db:create', 'unicorn:stop'
  before 'db:create', 'db:drop'
  after 'deploy:update_code', 'db:seed'
end

if ENV['test']
  after 'db:seed', 'db:load_sample'
end

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
	run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
	logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

namespace :shared do
  task :symlinks, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
    run "ln -nfs #{shared_path}/config/rvmrc #{latest_release}/.rvmrc"
  end
end

namespace :db do
  task :create, :roles => :app do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec rake db:create"
  end

  task :drop, :roles => :app do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec rake db:drop"
  end

  task :seed, :roles => :app do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} bundle exec rake db:seed --trace"
  end

  task :load_sample, :roles => :app do
    run "cd #{latest_release}; RAILS_ENV=#{rails_env} more_samples=true bundle exec rake db:load_sample --trace"
  end
end

desc "tail production log files"
task :tail_logs, :roles => :app do
  log_file = case ENV['log']
	     when 'd' then 'delayed_job.log'
	     else "#{rails_env}.log"
	     end

  run "tail -f #{File.join(shared_path, 'log', log_file)}" do |channel, stream, data|
    puts  # for an extra line break before the host name
    puts "#{channel[:host]}: #{data}"
    break if stream == :err
  end
end

require 'capistrano-unicorn'

namespace :unicorn do
  desc 'Reload unicorn'
  task :reload, :roles => :app, :except => {:no_release => true} do
    config_path = "#{current_path}/config/unicorn/#{rails_env}.rb"
    if remote_file_exists?(unicorn_pid)
      logger.important("Stopping...", "Unicorn")
      run "kill -s USR2 `cat #{unicorn_pid}`"
    else
      logger.important("No PIDs found. Starting Unicorn server...", "Unicorn")
      if remote_file_exists?(config_path)
	run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec unicorn -c #{config_path} -E #{rails_env} -D"
      else
	logger.important("Config file for \"#{unicorn_env}\" environment was not found at \"#{config_path}\"", "Unicorn")
      end
    end
  end
end
