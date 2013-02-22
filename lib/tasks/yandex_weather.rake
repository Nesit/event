namespace :weather do
  task :update => :environment do
    site_config = SiteConfig.first
    site_config ||= SiteConfig.new
    site_config.load_weather_data
    site_config.save!
  end
end
