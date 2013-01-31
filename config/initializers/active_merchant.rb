require 'active_merchant/billing/integrations/action_view_helper'

class ActionView::Base
  include ActiveMerchant::Billing::Integrations::ActionViewHelper
end

module Robokassa
  if Rails.env.production?
    Login = 'event'
    Password1 = 'rfhfutjpbc1q2w3e4r1'
    Password1 = 'rfhfutjpbc1q2w3e4r2'
  else
    Login = 'event_test_account'
    Password1 = 'asdf123bvg'
    Password2 = 'asdf123bvg2'
  end
end