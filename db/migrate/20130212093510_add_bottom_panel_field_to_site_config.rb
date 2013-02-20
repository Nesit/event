class AddBottomPanelFieldToSiteConfig < ActiveRecord::Migration
  def change
    add_column :site_configs, :bottom_menu, :text
  end
end
