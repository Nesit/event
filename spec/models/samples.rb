require 'spec_helper'

describe "Samples" do
  fixtures :articles
  fixtures :users

  samples = {
    articles: [:news_article, :event_article, :closed_news_article],
    users: [:user1, :user2],
    subscriptions: [:expired_subscription1, :active_subscription2, :pending_subscription3],
  }

  samples.each do |model_sym, fixtures_syms|
    fixtures_syms.each do |sym|
      its "#{model_sym.inspect} fixture #{sym.inspect} is valid" do
        send(model_sym, sym).should be_valid
      end
    end
  end

  its "articles fixtures should be valid" do
    articles(:news_article).should be_valid
    articles(:event_article).should be_valid
    articles(:closed_news_article).should be_valid
  end

  its "articles fixtures should be valid" do
    articles(:news_article).should be_valid
    articles(:event_article).should be_valid
    articles(:closed_news_article).should be_valid
  end
end
