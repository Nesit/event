# -*- coding: utf-8 -*-
ActiveAdmin.register PartnerNewsletter do
  menu label: "Рассылка партнёров"
  actions :all, :except => [:show]

  filter :state, as: :select,
                 collection: %w[pending in_progress done reject].map {|s| [I18n.t(s), s]},
                 include_blank: true

  [:reject, :activate].each do |_method|
    member_action _method, :method => :put do
      newsletter = PartnerNewsletter.find(params[:id])
      newsletter.send(_method)
      redirect_to({:action => :index})
    end
  end

  index do
    id_column
    column :title
    column :state do |resource|
      I18n.t(resource.state)
    end
    column "" do |resource|
      links = ''.html_safe
      links += link_to I18n.t('active_admin.edit'), edit_resource_path(resource),
                                                    :class => "member_link edit_link"
      links += link_to I18n.t('active_admin.delete'), resource_path(resource),
                                                      :method => :delete,
                                                      :confirm => I18n.t('active_admin.delete_confirmation'),
                                                      :class => "member_link delete_link"

      links += case resource.state
               when 'pending'
                 link_to 'Отменить', reject_admin_partner_newsletter_path(resource), :method => :put,
                                                                                     :class  => "member_link edit_link"
               when 'reject'
                 link_to 'Активировать', activate_admin_partner_newsletter_path(resource), :method => :put,
                                                                                           :class  => "member_link edit_link"
               end
      links
    end
  end

  form partial: "partner_newsletters/admin_form"

end
