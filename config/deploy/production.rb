set :stage, 'production'

role :web, 'event.balticit.ru'
role :app, 'event.balticit.ru'
role :db,  'event.balticit.ru', :primary => true

set :user, 'rvm_user'
set :deploy_to, '/var/www/apps/event_production'

set :rails_env, 'production'
set :branch, 'master'
set :unicorn_env, 'production'
set :keep_releases, 10
set :app_env, 'production'

set :current_path, File.join(deploy_to, current_dir) #fix for capistrano-unicorn

after 'deploy:update_code', 'deploy:migrate'

#before 'sphinx:stop', 'sphinx:configure'
#before 'db:drop', 'unicorn:stop', 'sphinx:stop'

#before 'unicorn:restart', 'sphinx:rebuild'
#before 'unicorn:restart', 'deploy:symlink_robots'
#after 'unicorn:restart', 'weather:update'
