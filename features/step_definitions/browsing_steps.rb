Given /^I am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )follow ([^:"]+)$/ do |link|
  find(selector_for(link)).click
end

When /^I fill within ([^:"]+) with$/ do |scope, table|
  within(selector_for(scope)) do
    hash = table.hashes.first
    hash.each do |key, value|
      fill_in(key.to_s, with: value)
    end
  end
end

When /^I click on submit button within ([^:"]+)$/ do |scope|
  within(selector_for(scope)) do
    find('input[type=submit]').click
  end
end

Then /^I should see "(.*?)" within ([^:"]+)$/ do |text, scope|
  find(selector_for(scope)).should have_content(text)
end

Then /^I should see "(.*?)"$/ do |text|
  page.should have_content(text)
end

Then /^I should see tag "(.*?)"$/ do |tag|
  page.should have_selector(tag)
end

When /^([^:"]+) should not be visible$/ do |element|
  steps %{
    Then #{element} should not be visible within the body
  }
end

When /^([^:"]+) should be visible$/ do |element|
  steps %{
    Then #{element} should be visible within the body
  }
end

Then /^([^:"]+) should not be visible within ([^:"]+)$/ do |what, where|
  within(selector_for(where)) do
    element = first(:css, selector_for(what))
    element.should_not be_visible unless element.blank?
  end
end

Then /^([^:"]+) should be visible within ([^:"]+)$/ do |what, where|
  within(selector_for(where)) do
    element = first(:css, selector_for(what))
    element.should be_visible
  end
end

Then /^([^:"]+) should be readonly$/ do |element|
  find(selector_for(element))['readonly'].should_not be_blank
end

Then /^([^:"]+) should not be readonly$/ do |element|
  find(selector_for(element))['readonly'].should be_blank
end

When /^I wait for ajax$/ do
  start_time = Time.now
  active_lambda = lambda { page.evaluate_script('jQuery.isReady&&jQuery.active==0') }
  active_lambda.call.class.should_not eql(String) until active_lambda.call or (start_time + 5.seconds) < Time.now do
    sleep 1
  end
end

Then /^show me the page$/ do
  save_and_open_page
end
