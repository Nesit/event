# -*- coding: utf-8 -*-
class UserMailer < ActionMailer::Base
  default :from => "no-reply@event.ru"

  def user_banned(user)
    @user = user
    mail(to: @user.email,
         subject: "Вы забанены")
  end

  def user_unbanned(user)
    @user = user
    mail(to: @user.email,
         subject: "Вы разбанены")
  end

  def user_deleted(user)
    @user = user
    mail(to: @user.email,
         subject: "Вы удалены")
  end
end
