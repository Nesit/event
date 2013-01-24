require 'spec_helper'

describe Subscription do
  before(:all) do
    @user = FactoryGirl.create(:user_complete)
  end
  
  it "fills :activated_at and :ended_at fields when activated" do
    sub = FactoryGirl.build(:pending_subscription, user_id: @user.id)
    sub.kind = :one_year
    sub.should be_valid

    sub.save!
    sub.activate!

    sub.state.should == :active
    sub.activated_at.should == Date.today
    sub.ended_at.should == (Date.today + 1.year)
  end

  it "updates user's :active_subscription field when gets activated" do
    sub = FactoryGirl.create(:pending_subscription, user_id: @user.id)
    @user.active_subscription.should be_blank
    sub.activate!
    
    @user.reload
    @user.active_subscription.should be_true
  end

  its "state turns to :expired if :ended_at was earlier" do
    sub = FactoryGirl.create(:activated_subscription, user_id: @user.id)
    
    sub.ended_at = Date.yesterday
    sub.check_expiration!

    sub.should be_valid
    sub.state.should == :expired
  end

  it "updates user's :active_subscription field when gets activated" do
    sub = FactoryGirl.create(:activated_subscription, user_id: @user.id)

    sub.ended_at = Date.yesterday
    sub.check_expiration!

    @user.reload
    @user.active_subscription.should be_blank
  end
end
