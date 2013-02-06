class ApplicationController < ActionController::Base
  protect_from_forgery

  check_authorization

  def current_ability
    @current_ability ||= Ability.new(current_user, current_admin_user)
  end 
  
  # reset captcha code after each request for security
  after_filter :reset_last_captcha_code!, if: :need_to_reset_captcha?

  before_filter :assign_config

  after_filter :check_need_email

  def extract_id_from_slug(slug)
    slug.split('-').last.to_i
  end

  unless Rails.env.development?
    rescue_from "Exception" do |exception|
      ExceptionNotifier::Notifier
        .exception_notification(request.env, exception).deliver
      
      respond_to do |format|
        format.html { render 'home/page500', status: 500 }
      end
    end
    error404classes = [
      "ActiveRecord::RecordNotFound",
      "AbstractController::ActionNotFound",
      "ActionController::RoutingError"
    ]
    rescue_from(*error404classes) do
      respond_to do |format|
        format.html { render 'home/page404', status: 404 }
      end
    end
    rescue_from "CanCan::AccessDenied" do
      respond_to do |format|
        format.html { render 'home/page403', status: 403 }
      end
    end
  end

  protected

  def check_need_email
    if current_user and current_user.state == 'need_email'
      cookies['need_email'] = true
    else 
      cookies.delete('need_email')
    end
  end

  def need_to_reset_captcha?
    case "#{controller_name}##{action_name}"
    when 'users#create', 'users#new'
      true
    when 'subscriptions#create', 'subscriptions#new'
      true
    else
      if action_name == 'captcha'
        true
      else
        false
      end
    end
  end

  def assign_config
    @site_config = SiteConfig.first
  end

  def not_authenticated
    # TODO 403
    head :access_denied
  end

  # TODO: Add default seo data
  # OPTIMIZE: I guess that is not best solution
  # For add seo tags to page, it's ease to use
  # Example:
  # seo_tags(Article.first, title: Article.first.title)
  def seo_tags(obj, *model_methods)
    @seo_tags = {}
    model_methods = model_methods.first
    %w[title description keywords image].each do |field|
      @seo_tags.merge!({ field.to_sym => obj.send(model_methods[field.to_sym]) }) if model_methods.has_key?(field.to_sym)
    end
    @seo_tags
  end
end
