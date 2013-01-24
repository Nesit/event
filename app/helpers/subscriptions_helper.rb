# encoding: utf-8

module SubscriptionsHelper
  def description_for_subscription(subscription)
    part = 
      case subscription.kind
      when :six_months
        "6 месяцев"
      when :one_year
        "1 год"
      when :two_years
        "2 года"
      end
    
    if subscription.print_versions_by_courier
      "Премиум подписка - #{part}"
    else
      "Подписка - #{part}"
    end
  end
end