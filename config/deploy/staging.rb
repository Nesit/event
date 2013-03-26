set :stage, 'staging'

role :web, 'stage.event.elzar.srv.balticit.ru'
role :app, 'stage.event.elzar.srv.balticit.ru'
role :db,  'stage.event.elzar.srv.balticit.ru', :primary => true

set :user, 'event'
set :deploy_to, '/var/www/event_staging'

set :rails_env, 'staging'
set :branch, 'stage'
set :unicorn_env, 'staging'
set :keep_releases, 5
set :app_env, 'staging'

set :rake, "#{File.join shared_path, 'scripts/rvm_wrapper.sh'} #{rake}"

after 'deploy:symlink_shared', 'deploy:symlink_sphinx_config'

before 'sphinx:stop', 'sphinx:configure'
before 'db:drop', 'unicorn:stop', 'sphinx:stop'
before 'db:create', 'db:drop'
after 'db:seed', 'db:load_sample'

before 'unicorn:restart', 'sphinx:rebuild'
before 'unicorn:restart', 'deploy:symlink_robots'
after 'unicorn:restart', 'weather:update'
