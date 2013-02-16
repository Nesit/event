class CommentsController < ApplicationController
  authorize_resource
  
  def create
    @comment = Comment.new params[:comment]
    @comment.author_id = current_user.id
    @comment.save!
    redirect_to @comment.topic
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.body = params[:comment][:body]
    @comment.save!
    head :ok
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.state = 'removed_by_owner'
    @comment.save!
    head :ok
  end

  def index
    @comments = Comment.where(topic_type: params[:topic_type],
                              topic_id: params[:topic_id]).page(params[:page])
    render layout: false
  end
end
