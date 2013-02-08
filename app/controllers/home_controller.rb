# encoding: utf-8

class HomeController < ApplicationController
  authorize_resource class: false

  def show
    @carousel_articles = Article.without_tv.newer_published.first(5)
    @afisha_articles = EventArticle.newer_targeted.first(6)
    @articles = Article.without_tv.newer_published.page(params[:page]).per(10)
    @seo_tags ||= {}
    @seo_tags[:title] = "Event.ru - информационный портал event-индустрии"
    render template: 'articles/index'
  end

  def page500
  end

  def page404
  end

  def page403
  end

  def none
    head :not_found
  end
end
