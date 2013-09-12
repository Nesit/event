require File.expand_path('../boot', __FILE__)

require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_resource/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end

module Event
  class Application < Rails::Application
    config.time_zone = 'Moscow'
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.default_locale = :ru
    config.i18n.locale = :ru

    # TODO: Vova, I guess that this already fixed
    # hotfix https://github.com/gregbell/active_admin/issues/999
    config.after_initialize do |app|
      if defined?(ActiveAdmin) and ActiveAdmin.application
        # Try enforce reloading after app bootup
        Rails.logger.debug("Reloading AA")
        ActiveAdmin.application.unload!
        I18n.reload!
        self.reload_routes!
      end
    end


    config.encoding = "utf-8"
    config.filter_parameters += [:password]
    config.active_support.escape_html_entities_in_json = true
    config.active_record.whitelist_attributes = true
    config.assets.enabled = true
    config.assets.version = '1.0'

    config.generators do |g|
      g.test_framework :rspec, fixtures: false,
                               helper_specs: false,
                               view_specs: false,
                               controller_specs: false
      g.rails old_style_hash: true,
              stylesheets: false,
              javascripts: false,
              helper: false
    end
  end
end
