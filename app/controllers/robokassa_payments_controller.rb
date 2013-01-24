class RobokassaPaymentsController < ApplicationController
  authorize_resource class: false

  before_filter :create_notification
  before_filter :find_payment

  include ActiveMerchant::Billing::Integrations

  def paid
    if @notification.acknowledge
      @subscription.activate!
      render :text => @notification.success_response
    else
      head :bad_request
    end
  end
  
  def success
    if @subscription.state != :active && @notification.acknowledge
      @subscription.activate!
    end
  end

  def fail
  end

  private

  def create_notification
    @notification = Robokassa::Notification.new(request.query_string, secret: ::Robokassa::Password1)
  end

  def find_payment
    @subscription = Subscription.find(@notification.item_id)
  end
end
