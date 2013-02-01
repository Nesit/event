set :output, nil

every 1.day, :at => '1:00 am' do
  rake "unicorn:reload"
end

every 1.day, :at => '3:00 am' do
  rake "subscription:check_expiration"
end

