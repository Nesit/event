class AddWeatherFieldToSiteConfig < ActiveRecord::Migration
  def change
    add_column :site_configs, :weather, :text
  end
end
