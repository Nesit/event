# encoding: utf-8

Given /^the following user registered:$/ do |table|
  hashes = table.hashes
  FactoryGirl.create(:user, hashes.first).activate!
end
