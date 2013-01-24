# encoding: utf-8

Given /^login dialog is shown$/ do
  steps %{
    When I follow login link
    Then login dialog should be visible
  }
end

Given /^register dialog is shown$/ do
  steps %{
    When I follow register link
    Then register dialog should be visible
  }
end

Given /^I am not logged in$/ do
  unless first(:css, "#auth-block")
    steps %{
      Given I am on the main page
    }
  end

  if page.has_content?("Выйти")
    steps %{
      When I follow "Выйти"
    }
  end
end

When /^I enter right captcha within register form$/ do
  # TODO
  page.driver.browser.manage.add_cookie name: :force_captcha, value: 'VALID'
  within(selector_for('register form')) do
    fill_in('captcha', with: 'VALID')
  end
end

Given /^I am logged in with:$/ do |table|
  hash = table.hashes.first
  
  unless first(:css, selector_for("login form"))
    steps %{
      Given I am on the main page
    }
  end

  steps %{
    Given login dialog is shown
    When I fill within login form with
      | email            | password |
      | #{hash['email']} | password |
    And I click on submit button within login form
    And I wait for ajax
    Then I should see "Профиль"
  }
end

Given /^I am logged in as user without additional info$/ do
  @user = FactoryGirl.create(:user_need_info)
  @user.activate!
  steps %{
    Given I am logged in with:
      | email         | password         |
      | #{@user.email} | #{@user.password} |
  }
end

Given /^I am logged in as user without email$/ do
  @user = FactoryGirl.create(:user_need_email)
  @user.activate!
  steps %{
    Given I am logged in with:
      | email         | password         |
      | #{@user.email} | #{@user.password} |
  }
end

Given /^I am logged in as user with complete info$/ do
  @user = FactoryGirl.create(:user_complete)
  @user.activate!
  steps %{
    Given I am logged in with:
      | email         | password         |
      | #{@user.email} | #{@user.password} |
  }
end
