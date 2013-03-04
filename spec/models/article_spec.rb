require 'spec_helper'

describe Article do
  after(:each) do
    Timecop.return
  end

  it "Should show all article thursday - monday" do
    novelty1 = FactoryGirl.create(:news_article, published_at: Time.zone.parse('14.02.2013'))
    novelty2 = FactoryGirl.create(:news_article, published_at: Time.zone.parse('18.02.2013 22:11:00'))
    novelty3 = FactoryGirl.create(:news_article, published_at: Time.zone.parse('19.02.2013 00:11:00'))
    novelty4 = FactoryGirl.create(:news_article, published_at: Time.zone.parse('17.02.2013 00:11:00'), published: false)

    Timecop.freeze(Time.zone.parse('18.02.2013 23:00:00')) do
      NewsArticle.published_to_monday.count.should == 2
      [novelty3, novelty4].each do |novelty|
        lambda{ NewsArticle.published_to_monday.find(novelty) }.should raise_error(ActiveRecord::RecordNotFound)
      end
      [novelty1, novelty2].each do |novelty|
        NewsArticle.published_to_monday.find(novelty).should == novelty
      end
    end
  end

  it "Should show all article monday - thursday" do
    novelty1 = FactoryGirl.create(:news_article, published_at: Time.zone.parse('11.02.2013'))
    novelty2 = FactoryGirl.create(:news_article, published_at: Time.zone.parse('14.02.2013 22:11:00'))
    novelty3 = FactoryGirl.create(:news_article, published_at: Time.zone.parse('15.02.2013 00:11:00'))

    Timecop.freeze(Time.zone.parse('14.02.2013 23:00:00')) do
      NewsArticle.published_to_thursday.count.should == 2
      [novelty3].each do |novelty|
        lambda{ NewsArticle.published_to_thursday.find(novelty) }.should raise_error(ActiveRecord::RecordNotFound)
      end
      [novelty1, novelty2].each do |novelty|
        NewsArticle.published_to_thursday.find(novelty).should == novelty
      end
    end
  end

end
