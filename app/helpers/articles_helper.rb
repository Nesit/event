module ArticlesHelper
  def can_see_closed?
    current_user and current_user.active_subscription?
  end

  def main_page?
    controller_name == "home" and (params[:page].nil? or params[:page].to_s.to_i == 1)
  end

  def display_article_category?
    params[:type].blank?
  end

  def display_article_category_title?
    not params[:type].blank?
  end

  def articles_path_for_article_class(klass)
    send("#{klass.name.underscore.pluralize}_path")
  end

  def article_body_as_html(article)
    article.body.html_safe
  end
end
