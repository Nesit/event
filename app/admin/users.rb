# -*- coding: utf-8 -*-
ActiveAdmin.register User do
  menu label: 'Пользователи'

  actions :all, :except => [:show]

  filter :email
  filter :name
  filter :company
  filter :city
  filter :banned
  filter :state, as: :select, collection: %w[need_email need_info complete disabled banned].
    map {|s| [I18n.t(s), s]}, include_blank: true

  controller do
    def update
      params[:user].delete_if {|k,v| k == 'password'} if (params[:user][:password] && params[:user][:password].empty?)
      super
    end
  end

  index do
    id_column
    column :name
    column :email
    column :state do |resource|
      I18n.t(resource.state)
    end
    default_actions
  end

  form do |f|
    f.inputs "Основное" do
      f.input :name
      f.input :email
      f.input :avatar, :as => :file, :hint => f.template.image_tag(f.object.avatar.url)
      f.input :banned, as: :select, collection: [['Да', true], ['Нет', false]], include_blank: false
      f.input :born_at
      f.input :gender_cd
      f.input :company
      f.input :position
      f.input :website
      f.input :phone_number
      f.input :city
      f.input :active_subscription
      f.input :article_comment_notification
      f.input :comment_notification
      f.input :event_notification
      f.input :partner_notification
      f.input :weekly_notification
    end
    f.inputs 'Пароль' do
      f.input :password
    end
    f.actions
  end

end
