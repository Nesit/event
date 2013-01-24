class HomeController < ApplicationController
  authorize_resource class: false

  def show
    @carousel_articles = Article.without_tv.newer.first(6)
    @afisha_articles = EventArticle.newer_targeted.first(6)
    @articles = Article.without_tv.newer.page(params[:page]).per(10)
    render template: 'articles/index'
  end
end
