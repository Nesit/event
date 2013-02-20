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
  filter :state, as: :select, collection: %w[need_info complete banned].
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

  form partial: 'users/admin_form'
end
