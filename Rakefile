#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

EventRu::Application.load_tasks

namespace :db do
  task load_sample: [:environment] do
    ENV["FIXTURES_PATH"] = "db/sample"
    Rake::Task['db:fixtures:load'].execute("default")
    ["articles", "article_authors", "article_body_images", "issues"].each do |filename|
      require Rails.root.join("db", "sample", filename)
    end
  end
end