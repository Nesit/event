# encoding: utf-8

class HomeController < ApplicationController
  authorize_resource class: false

  layout 'error_page', only: [:page404, :page403, :page500]

  def show
    articles = Article.without_tv.newer_published
    @articles = articles.page(params[:page]).per(10)
    @carousel_articles = @articles.first(5)
    @afisha_articles = EventArticle.newer_targeted.first(6)

    @seo_tags ||= {}
    @seo_tags[:title] = "Event.ru - информационный портал event-индустрии"
    render template: 'articles/index'
  end

  def page500
    if params[:format] and not params[:formst].in?(['html', 'htm'])
      head :error
    end
  end

  def page404
    if params[:format] and not params[:formst].in?(['html', 'htm'])
      head :not_found
    end
  end

  def page403
    if params[:format] and not params[:formst].in?(['html', 'htm'])
      head :access_denied
    end
  end

  def none
    head :not_found
  end
end
