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

  def event_subscriber(user)
    @events = NewsArticle.new_events_tuesday.group_by(&:target_at)
    return if @events.empty?
    mail(to: user.email, :subject => "Афиша Event.ru")
  end

  def partner_newsletter(user, newsletter)
    @newsletter = newsletter
    mail(to: user.email, :subject => "Event.ru рекомендует")
  end

  def comment_in_articles(user, articles)
    @user = user
    @articles = articles.class.name == 'Array' ? articles : [articles]
    mail(to: @user.email, :subject => "Уведомление о новом комментарии на сайте Event.ru")
  end

  def comment_comment(user, articles)
    @user = user
    @articles = articles.class.name =~ /Relation|Array/ ? articles : [articles]
    mail(to: @user.email, :subject => "Уведомление о новом комментарии на сайте Event.ru")
  end
end
