namespace :subscription do
  task :check_expiration => :environment do
    Subscription.active.each(&:check_expiration!)
  end
end
