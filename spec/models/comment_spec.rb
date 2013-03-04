# -*- coding: utf-8 -*-
require 'spec_helper'

describe Comment, current: true do
  include EmailSpec::Helpers
  include EmailSpec::Matchers
  include ::Rails.application.routes.url_helpers

  before(:each) do
    reset_mailer
  end

  # let(:user) { FactoryGirl.create(:user_complete) }
  let(:user2) { FactoryGirl.create(:user_complete) }

  describe "Comment comment notify" do
    let(:user) { FactoryGirl.create(:user_complete, active_subscription: true,
                                                    comment_notification: true,
                                                    article_comment_notification: false) }
    it "Should send notify immediately" do
      news_article = FactoryGirl.create(:news_article, title: 'article #1')
      user.last_email_comment.should == nil

      comment = FactoryGirl.create(:comment, topic: news_article, author: user)
      comment.new_record?.should == false
      user.last_email_comment.should == nil
      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should be_nil

      comment2 = FactoryGirl.create(:comment, topic: news_article, author: user2, ancestry: comment.id.to_s)
      User.find(user).last_email_comment.should_not be_nil
      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should_not be_nil
      email = open_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/)
      email.should have_body_text(/article #1/)
    end

    it "Should don't send notification because time has passed" do
      user.update_attribute(:last_email_comment, Time.zone.now)
      news_article = FactoryGirl.create(:news_article, title: 'article #1')

      comment = FactoryGirl.create(:comment, topic: news_article, author: user)

      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should be_nil
      comment2 = FactoryGirl.create(:comment, topic: news_article, author: user2, ancestry: comment.id.to_s)
      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should be_nil
    end

    it "Should send notification by bulk after wait time" do
      user.update_attribute(:last_email_comment, Time.zone.now)
      news_article = FactoryGirl.create(:news_article, title: 'article #1')
      comment = FactoryGirl.create(:comment, topic: news_article, author: user)
      comment2 = FactoryGirl.create(:comment, topic: news_article, author: user2, ancestry: comment.id.to_s)

      Timecop.freeze(Time.zone.now + 2.hour) do
        user.new_comments_in_comments.count.should == 0
      end

      Timecop.freeze(Time.zone.now + 3.hour) do
        user.new_comments_in_comments.count.should == 1
      end

    end
  end

  describe "Comment article" do
    it "Should send notify immediately" do
      user = FactoryGirl.create(:user_complete, active_subscription: true, article_comment_notification: true)
      news_article = FactoryGirl.create(:news_article, title: 'article #1')
      user.last_email_article.should == nil

      comment = FactoryGirl.create(:comment, topic: news_article, author: user)
      comment.new_record?.should == false
      user.last_email_article.should == nil
      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should be_nil

      comment2 = FactoryGirl.create(:comment, topic: news_article, author: user2)
      User.find(user).last_email_article.should_not be_nil
      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should_not be_nil
      email = open_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/)
      email.should have_body_text(/article #1/)
    end

    it "Should don't send notification because time has passed" do
      user = FactoryGirl.create(:user_complete, active_subscription: true, article_comment_notification: true)
      user.update_attribute(:last_email_article, Time.zone.now)

      news_article = FactoryGirl.create(:news_article, title: 'article #1')
      comment = FactoryGirl.create(:comment, topic: news_article, author: user)

      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should be_nil
      comment2 = FactoryGirl.create(:comment, topic: news_article, author: user2)
      find_email(user.email, with_subject: /Уведомление о новом комментарии на сайте/).should be_nil
    end

    it "Should send notification by bulk after wait time" do
      user = FactoryGirl.create(:user_complete, active_subscription: true, article_comment_notification: true)
      user.update_attribute(:last_email_article, Time.zone.now)
      news_article = FactoryGirl.create(:news_article, title: 'article #1')
      comment = FactoryGirl.create(:comment, topic: news_article, author: user)

      Timecop.freeze(Time.zone.now + 2.hour) do
        user.new_comments_in_articles.count.should == 0
      end
      Timecop.freeze(Time.zone.now + 3.hour) do
        user.new_comments_in_articles.count.should == 1
      end
    end
  end

end
