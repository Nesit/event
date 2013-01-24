# encoding: utf-8

require 'spec_helper'

describe User do
  its "factories are valid" do
    user = FactoryGirl.create(:user_need_email)
    user.should be_valid

    user = FactoryGirl.create(:user_need_info)
    user.should be_valid

    user = FactoryGirl.create(:user_complete)
    user.should be_valid
  end

  it "turns :state to :need_email if no email supplied" do
    user = User.new
    user.should be_valid

    user.state.should == 'need_email'
  end

  it "turns :state to :need_info if email is present and not enough info" do
    user = User.new
    user.email = "whatever@example.com"
    user.should be_valid
    user.state.should == 'need_info'
  end

  it "turns :state to :complete if email and additional info is supplied" do
    user = User.new

    user.email = "whatever@example.com"
    user.name = "Bob"
    user.city = FactoryGirl.create(:city)
    user.born_at = DateTime.now
    user.gender = :male
    user.company = "BalticIT"
    user.position = "Уборщик"
    user.website = "www.balticit.ru"

    user.should be_valid
    user.state.should == 'complete'
  end
end
