# encoding: utf-8

ActiveAdmin.register SiteConfig do
  menu label: "Настройки"
  actions :all, except: [:new]

  controller do
    def index
      if @site_config = SiteConfig.first
        redirect_to edit_admin_site_config_path(@site_config)
      else
        redirect_to new_admin_site_config_path
      end
    end
  end

  form do |f|
    f.inputs "Актуально сегодня" do
      f.input :actual_article
      f.input :actual_article_description
    end

    f.inputs "Баннер в списке статей" do
      f.input :article_list_banner_after
      f.input :article_list_banner_body
    end

    f.actions
  end
end
