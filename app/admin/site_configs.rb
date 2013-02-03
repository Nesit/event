# encoding: utf-8

ActiveAdmin.register SiteConfig do
  menu label: "Настройки"
  actions :all, except: [:new]

  controller do
    def index
      if @site_config = SiteConfig.first
        redirect_to edit_admin_site_config_path(@site_config)
      else
        @site_config = SiteConfig.create!
        redirect_to edit_admin_site_config_path(@site_config)
      end
    end
  end

  form partial: 'site_configs/admin_form'
end
