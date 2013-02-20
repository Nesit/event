namespace :newsletter do
  desc "Send weelky newsletter on Monday"
  task :weekly_monday => :environment do
    User.weekly_subscribers.each do |user|
      UserNotifyMailer.weekly_newsletter_monday(user).deliver
    end
  end

  desc "Send weelky newsletter on Thursday"
  task :weekly_thursday => :environment do
    User.weekly_subscribers.each do |user|
      UserNotifyMailer.weekly_newsletter_thursday(user).deliver
    end
  end

  desc "Send new events newsletter"
  task :event_subscriber => :environment do
    User.event_subscribers.each do |user|
      UserNotifyMailer.event_subscriber(user).deliver
    end
  end

  desc "Send partner newsletter"
  task :partner_newsletter => :environment do
    @newsletters = PartnerNewsletter.need_to_send
    next if @newsletters.empty?
    @newsletters.each do |newsletter|
      newsletter.in_progress
      User.partner_notifications.each do |user|
        UserNotifyMailer.partner_newsletter(user, newsletter).deliver
      end
      newsletter.done
    end
  end
end
