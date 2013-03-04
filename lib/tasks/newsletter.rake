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
    @newsletters.each {|nw| nv.in_progress}
    @newsletters.each do |newsletter|
      User.partner_notifications.each do |user|
        UserNotifyMailer.partner_newsletter(user, newsletter).deliver
      end
      newsletter.done
    end
  end

  task :comment_article => :environment do
    User.article_comments.each do |user|
      articles = user.new_comments_in_articles
      next if articles.empty?
      UserNotifyMailer.comment_in_articles(user, articles).deliver
    end
  end

  task :comment_comment => :environment do
    User.comment_notifications.each do |user|
      articles = user.new_comments_in_comments
      next if articles.empty?
      UserNotifyMailer.comment_comment(user, articles).deliver
    end
  end
end
