set :stage, 'staging'

role :web, 'stage.event.balticit.ru'
role :app, 'stage.event.balticit.ru'
role :db,  'stage.event.balticit.ru', :primary => true

set :user, 'rvm_user'
set :deploy_to, '/var/www/apps/event_staging'

set :rails_env, 'staging'
set :branch, 'stage'
set :unicorn_env, 'staging'
set :keep_releases, 5
set :app_env, 'staging'

after 'deploy:symlink_shared', 'deploy:symlink_sphinx_config'

before 'sphinx:stop', 'sphinx:configure'
before 'db:drop', 'unicorn:stop', 'sphinx:stop'
before 'db:create', 'db:drop'
after 'db:seed', 'db:load_sample'

before 'unicorn:restart', 'sphinx:rebuild'
before 'unicorn:restart', 'deploy:symlink_robots'
after 'unicorn:restart', 'weather:update'
after 'unicorn:restart', 'whenever:update'
