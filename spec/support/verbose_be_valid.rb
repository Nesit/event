RSpec::Matchers.define :be_valid do
  match do |model|
    model.valid?
  end

  failure_message_for_should do |model|
    "expected valid? to return true, got false:\n #{model.errors.full_messages.join("\n ")}"
  end

  failure_message_for_should_not do |model|
    "expected valid? to return false, got true"
  end

  description do
    "be valid"
  end
end