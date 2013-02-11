class SubscriptionsController < ApplicationController
  authorize_resource

  layout 'empty', only: [:pay]

  def index
    @subscriptions = [current_user.pending_subscription, current_user.subscriptions.active.newer.first(10)]
    @subscriptions = @subscriptions.flatten.compact
  end

  def new
  end

  def pay
    @subscription = Subscription.find(params[:subscription_id])
  end

  def create
    @subscription =
      if current_user
        subscription_for_logged_user
      else
        subscription_for_guest
      end
    render json: { url: subscription_pay_path(@subscription) }
  end

  def subscription_for_logged_user
    current_user.subscriptions.create!(params[:subscription])
  end

  def subscription_for_guest
    if valid_captcha?(params[:captcha])
      @user = User.new(email: params[:email])
      @user.save!

      @user.subscriptions.create!(params[:subscription])
    else
      raise "invalid captcha"
    end
  end

  def destroy
    @subscription = Subscription.where(state: :pending).find(params[:id])
    @subscription.destroy
    redirect_to user_subscriptions_path
  end
end
