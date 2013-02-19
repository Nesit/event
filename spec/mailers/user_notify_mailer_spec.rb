# -*- coding: utf-8 -*-
require "spec_helper"

describe UserNotifyMailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ::Rails.application.routes.url_helpers

  before(:each) do
    reset_mailer
  end

  let (:user) { FactoryGirl.create(:user_complete, weekly_notification: true, active_subscription: true) }

  it "Should send newslatter" do
    [Time.zone.now.monday, Time.zone.now.monday, Time.zone.now.monday + 1.day].each do |dt|
      FactoryGirl.create(:news_article, published_at: dt)
    end
    NewsArticle.stub(:published_to_monday).and_return NewsArticle.scoped
    mail = UserNotifyMailer.weekly_newsletter_monday(user).deliver
    mail.subject.should == 'Вас непременно это заинтересует!'
    mail.from.should == ['robot@event.ru']
  end
end
