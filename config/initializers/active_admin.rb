class ActiveAdmin::BaseController
  skip_authorization_check
end

class ActiveAdmin::Devise::SessionsController
  skip_authorization_check
end

ActiveAdmin.setup do |config|
  config.site_title = "Event Ru"
  config.authentication_method = :authenticate_admin_user!
  config.current_user_method = :current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.batch_actions = true
  config.before_filter :set_admin_locale
end

module ActiveAdmin
  ResourceController.class_eval do
    with_role :admin
  end
end
