# encoding: utf-8

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

  def prev_article_label(article)
    label = t("articles.previous.#{article.class.name}")
    "<span class=\"arrow\">‹ </span>#{label}".html_safe
  end

  def next_article_label(article)
    label = t("articles.next.#{article.class.name}")
    "#{label}<span class=\"arrow\"> ›</span>".html_safe
  end

  def embeded_video_tag(kind, code, width, height)
    source =
      case kind
      when 'youtube'
        <<-HTML
          <iframe width="#{width}" height="#{height}"
              src="http://www.youtube.com/embed/#{code}?wmode=opaque"
              frameborder="0" allowfullscreen>
          </iframe>
        HTML
      when 'vimeo'
        <<-HTML
          <iframe src="http://player.vimeo.com/video/#{code}"
              width="#{width}" height="#{height}" frameborder="0"
              webkitAllowFullScreen mozallowfullscreen allowFullScreen>
          </iframe>
        HTML
      end
    source.html_safe
  end
end
