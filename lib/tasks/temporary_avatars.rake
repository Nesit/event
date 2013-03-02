namespace :temporary_avatars do
  task :cleanup => :environment do
    TemporaryAvatar.cleanup!
  end
end
