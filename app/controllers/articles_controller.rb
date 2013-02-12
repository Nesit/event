class ArticlesController < ApplicationController
  authorize_resource

  before_filter :assign_article, only: [:show]

  def index
    @articles = Article.published
    @articles = @articles.where(type: params[:type]) if params[:type]
    
    if params[:tag_id]
      tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
      @articles = @articles.tagged_with(tag)
    end

    @articles =
      case params[:type]
      when 'EventArticle'
        @articles.newer_targeted.page(params[:page]).per(10)  
      else
        @articles.newer_published.page(params[:page]).per(10)  
      end
  end

  def show
    @article.record_pageview!
    seo_tags(@article, title: :title, description: :short_description, image: :head_image)
  end

  def preview
    klass = params[:type].constantize
    raise "Wrong article type: #{params[:type]}" unless klass.superclass == Article
    @article = klass.find(params[:id])
    render 'show'
  end

  private

  def assign_article
    klass = params[:type].constantize
    raise "Wrong article type: #{params[:type]}" unless klass.superclass == Article
    @article = klass.published.find(params[:id])
  end
end
