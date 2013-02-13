# encoding: utf-8

ActiveAdmin.register SiteConfig do
  menu label: "Настройки"
  actions :all, except: [:new]

  controller do
    def parse_menu
      params[:site_config][:bottom_menu] =
        {'items' => JSON(params[:site_config][:bottom_menu])}
    end

    def index
      if @site_config = SiteConfig.first
        redirect_to edit_admin_site_config_path(@site_config)
      else
        @site_config = SiteConfig.create!
        redirect_to edit_admin_site_config_path(@site_config)
      end
    end

    def update
      parse_menu
      super
    end

    def create
      parse_menu
      super
    end
  end

  form partial: 'site_configs/admin_form'
end
