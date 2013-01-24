ENV["FIXTURES_PATH"] = "db/default"
Rake::Task['db:fixtures:load'].execute("default")