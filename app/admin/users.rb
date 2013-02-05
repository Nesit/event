# -*- coding: utf-8 -*-
ActiveAdmin.register User do
  menu label: 'Пользователи'

  actions :all, :except => [:show]

  scope :all, default: true
  scope :with_subscription

  filter :email
  filter :name
  filter :company
  filter :city
  filter :state, as: :select, collection: %w[need_email need_info complete banned].
    map {|s| [I18n.t(s), s]}, include_blank: true

  controller do
    def update
      params[:user].delete_if {|k,v| k == 'password'} if (params[:user][:password] && params[:user][:password].empty?)
      super
    end
  end

  member_action :banned, :method => :put do
    user = User.find(params[:id])
    user.banned!
    redirect_to edit_admin_user_path(user), :notice => "Banned!"
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
      f.input :state, as: :select, collection: %w[need_email need_info complete banned].
        map {|s| [I18n.t(s), s]}, include_blank: true, input_html: {disabled: true}
      f.input :avatar, :as => :file, :hint => f.template.image_tag(f.object.avatar.url)
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
    f.inputs 'Действия' do
      link_to('Забанить', banned_admin_user_path(resource), method: :put) unless resource.banned?
    end
    f.actions

  end

end
