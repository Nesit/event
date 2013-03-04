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



every :monday, :at => '12pm' do
  rake 'newsletter:weekly_monday'
end

every :thursday, :at => '12pm' do
  rake 'newsletter:weekly_thursday'
end

every :tuesday, :at => '12pm' do
  rake 'newsletter:event_subscriber'
end

every 10.minutes do
  rake 'newsletter:partner_newsletter'
end

every 20.minutes do
  rake 'newsletter:comment_article'
end

every 20.minutes do
  rake 'newsletter:comment_comment'
end
