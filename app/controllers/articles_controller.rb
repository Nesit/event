class ArticlesController < ApplicationController
  authorize_resource

  before_filter :assign_article, only: [:show]

  def index
    @articles = 
      case params[:type]
      when 'EventArticle'
        if (params[:page].to_i < 2)
          @afisha_articles = EventArticle.newer_targeted.first(6)
          EventArticle.published.newer_targeted
        end
        
      when nil
        Article.published.newer_published
      else
        Article.published.newer_published.where(type: params[:type])
      end
    
    if params[:tag_id]
      tag = ActsAsTaggableOn::Tag.find(params[:tag_id])
      @articles = @articles.tagged_with(tag)
    end

    @articles = @articles.page(params[:page]).per(10)
    @articles = @articles.padding(6) if params[:type] == 'EventArticle' and (params[:page].to_i < 2)
  end

  def search
    @articles = Article.search params[:term],
      field_weights: { title: 10, body: 3 },
      page: params[:page],
      per_page: 10
    render 'index'
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
