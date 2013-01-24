require 'active_merchant/billing/integrations/action_view_helper'

class ActionView::Base
  include ActiveMerchant::Billing::Integrations::ActionViewHelper
end

module Robokassa
  Login = 'event_test_account'
  Password1 = 'asdf123bvg'
  Password2 = 'asdf123bvg2'
end