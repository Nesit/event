require 'active_record/fixtures'

namespace :db do
  desc 'db:drop db:create db:migrate db:seed db:load_sample'
  task :setup_sample => :environment do
    ['db:drop', 'db:create', 'db:migrate', 'db:seed', 'db:load_sample'].each do |t|
      Rake::Task[t].execute
    end
  end

  desc "Loads a specified fixture using rake db:load_file[filename.rb]"
  task :load_file , [:file] => :environment do |t , args|
    file = args.file
    ext = File.extname file
    if ext == ".csv" or ext == ".yml"
      puts "loading fixture " + file
      start_time = Time.now
      ActiveRecord::Fixtures.create_fixtures(File.dirname(file) , File.basename(file, '.*') )
      puts "Time for '#{file}':  #{Time.now - start_time}" if ENV['sample_time']
    else
      if File.exists? file
        puts "loading ruby    " + file
        start_time = Time.now
        require file
        puts "Time for '#{file}':  #{Time.now - start_time}" if ENV['sample_time']
      end
    end
  end

  desc "Loads fixtures from the the dir you specify using rake db:load_dir[loadfrom]"
  task :load_dir , [:dir] => :environment do |t , args|
    dir = args.class == String ? args : args.dir
    fixtures = ActiveSupport::OrderedHash.new
    ruby_files = ActiveSupport::OrderedHash.new
    Dir.glob(File.join(Rails.root, "db", dir , '*.{yml,csv,rb}')).each do |fixture_file|
      ext = File.extname fixture_file
      if ext == ".rb"
        ruby_files[File.basename(fixture_file, '.*')]  = fixture_file
      else
        fixtures[File.basename(fixture_file, '.*')]  = fixture_file
      end
    end
    fixtures.sort.each do |fixture , fixture_file|
      # an invoke will only execute the task once
      Rake::Task["db:load_file"].execute( Rake::TaskArguments.new([:file], [fixture_file]) )
    end
    ruby_files.sort.each do |fixture , ruby_file|
      # an invoke will only execute the task once
      Rake::Task["db:load_file"].execute( Rake::TaskArguments.new([:file], [ruby_file]) )
    end
  end

  desc "Load sample"
  task :load_sample => :environment do
    Rake::Task["db:load_dir"].execute('sample')
    puts "Sample data has been loaded"
  end
end
