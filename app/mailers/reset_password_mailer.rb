# encoding: utf-8

class ResetPasswordMailer < ActionMailer::Base
  default :from => "no-reply@event.ru"
  
  # TODO
  def reset_password_email(user)
    @user = user
    mail(to: user.email, subject: "event.ru - Сброс пароля")
  end
end
