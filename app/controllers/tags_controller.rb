class TagsController < ApplicationController
  authorize_resource class: false
  
  def index
    tags = ActsAsTaggableOn::Tag.where('name LIKE ?', "#{params[:term]}%").first(10)
    render json: tags.map(&:name)
  end
end
