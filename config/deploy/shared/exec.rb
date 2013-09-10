namespace :rake_exec do
  desc "Run a rake task on a remote server."
  # run like: cap staging rake:invoke task=a_certain_task
  task :invoke do
    run("cd #{latest_release}; RAILS_ENV=#{rails_env} rake #{ENV['task']}")
  end
end