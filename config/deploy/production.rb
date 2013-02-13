set :stage, 'production'

role :web, 'event.ru'
role :app, 'event.ru'
role :db,  'event.ru', :primary => true

set :user, 'event_production'
set :deploy_to, '/var/www/event_production'

set :rails_env, 'production'
set :branch, 'master'
set :unicorn_env, 'production'
set :keep_releases, 10
set :app_env, 'production'

set :rake, "#{File.join shared_path, 'scripts/rvm_wrapper.sh'} #{rake}"
