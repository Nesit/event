# -*- coding: utf-8 -*-
ActiveAdmin.register User do
  menu label: 'Пользователи'

  actions :all, except: [:new]

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
    column :created_at
    column :activation_state do |user|
      if user.activation_state == 'pending'
        "нет"
      else
        "да"
      end
    end

    column :price do |user|
      if user.subscription.present?
        user.subscription.amount
      else
        ""
      end
    end

    column :ordered_at do |user|
      if user.ordered_at
        Russian.strftime(user.ordered_at, "%d %B %Y, %H:%M")
      else
        ""
      end
    end

    column :paid do |user|
      case
      when user.subscription.blank?
        ""
      when user.subscription.paid?
        "<strong class=\"green\">да</strong>"
      else
        "<strong class=\"red\">нет</strong>"
      end.html_safe
    end

    column :print_versions_by_courier do |user|
      case
      when user.subscription.blank?
        ""
      when user.subscription.print_versions_by_courier
        "да"
      else
        "нет"
      end
    end

    default_actions
  end

  form partial: 'users/admin_form'
end
