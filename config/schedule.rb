set :output, nil

every 1.day, :at => '1:00 am' do
  rake "unicorn:reload"
end

every 1.day, :at => '3:00 am' do
  rake "subscription:check_expiration"
end

every :monday, :at => '12pm' do
  rake 'newsletter:weekly_monday'
end

every :thursday, :at => '12pm' do
  rake 'newsletter:weekly_thursday'
end

every :tuesday, :at => '12pm' do
  rake 'newsletter:event_subscriber'
end

