require 'rubygems'
require 'spork'
require 'spork/ext/ruby-debug'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'
  require 'database_cleaner'
  require 'ffaker'
  require 'email_spec'
  require 'timecop'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/samples"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random"

    config.include MailerMacros

    config.before(:suite) do
      if ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'postgresql'
        DatabaseCleaner.strategy = :transaction
      else
        DatabaseCleaner.strategy = :truncation
      end
      DatabaseCleaner.clean_with(:truncation)

      Timecop.return
    end

    config.before(:each) do
      DatabaseCleaner.start
      reset_email
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end

  end
end

Spork.each_run do
  FactoryGirl.reload
  Dir["#{Rails.root}/app/models/**/*.rb"].each{|f| load f}
end
