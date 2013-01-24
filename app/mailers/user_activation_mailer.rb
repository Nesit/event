# encoding: utf-8

class UserActivationMailer < ActionMailer::Base
  def activation_needed_email(user)
    @user = user
    mail(to: user.email, subject: "event.ru - Активация учётной записи") do |format|
      format.html
      format.text 
    end
  end

  def activation_success_email(user)
    mail(to: user.email, subject: "event.ru - Учётная запись успешно активированна") do |format|
      format.html
      format.text 
    end
  end
end
