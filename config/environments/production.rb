ActiveMerchant::Billing::Base.integration_mode = :production

EventRu::Application.configure do
  config.cache_classes = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets = false
  config.assets.compress = true
  config.assets.compile = false
  config.assets.precompile += %w(application.css active_admin.css wysiwyg.css)
  config.assets.digest = true
  config.action_mailer.delivery_method = :sendmail
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.i18n.fallbacks = false
  config.active_support.deprecation = :notify

  # ExceptionNotifier
  config.middleware.use ExceptionNotifier, :email_prefix => "[Notify event.ru] ",
                                           :sender_address => %{"notify"},
                                           :exception_recipients => %w{ kremenev@balticit.ru gordeev@balticit.ru }
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = {
    host: "event.ru",
    port: 80,
  }
end
