set :output, nil

every 1.day, :at => '1:00 am' do
  rake "unicorn:reload"
end

every 1.day, :at => '3:00 am' do
  rake "subscription:check_expiration"
end

every 1.day, :at => '6:00 am' do
  rake "weather:update"
end

every 2.day, :at => '8:00 am' do
  rake "temporary_avatars:cleanup"
end