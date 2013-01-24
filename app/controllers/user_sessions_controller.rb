class UserSessionsController < ApplicationController
  authorize_resource class: false
  
  def create
    @user = login(params[:email], params[:password], params[:remember])
    if @user = login(params[:email], params[:password], params[:remember])
      render partial: 'shared/auth_block', status: :created
    else
      head :unprocessable_entity
    end
  end
  
  def destroy
    logout
    redirect_back_or_to root_path
  end
end
