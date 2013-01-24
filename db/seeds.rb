ENV["FIXTURES_PATH"] = "db/default"
Rake::Task['db:fixtures:load'].execute("default")
require Rails.root.join('db', 'default', 'admin_users')
