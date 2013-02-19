# -*- coding: utf-8 -*-
class UserNotifyMailer < ActionMailer::Base
  default :from => "robot@event.ru"

  def weekly_newsletter_monday(user)
    @news = NewsArticle.published_to_monday.group_by(&:published_at)
    return if @news.empty?
    mail(to: user.email, :subject => "Новые статьи на Event.ru")
  end

  def weekly_newsletter_thursday(user)
    @news = NewsArticle.published_to_thursday.group_by(&:published_at)
    return if @news.empty?
    mail(to: user.email, :subject => "Новые статьи на Event.ru")
  end
end
