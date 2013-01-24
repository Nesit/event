class ArticleGalleriesController < ApplicationController
  authorize_resource

  def show
    @gallery = ArticleGallery.find(params[:id])
    render layout: false
  end
end
