# encoding: utf-8

class ResetPasswordMailer < ActionMailer::Base
  # TODO
  def reset_password_email(user)
    @user = user
    mail(to: user.email, subject: "event.ru - Сброс пароля")
  end
end
