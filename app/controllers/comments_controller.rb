class CommentsController < ApplicationController
  authorize_resource
  
  def create
    @comment = Comment.new params[:comment]
    @comment.author_id = current_user.id
    @comment.save!
    redirect_to @comment.topic
  end

  def index
    @comments = Comment.where(topic_type: params[:topic_type],
                              topic_id: params[:topic_id]).page(params[:page])
    render layout: false
  end
end
