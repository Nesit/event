# encoding: utf-8

class UsersController < ApplicationController
  authorize_resource

  def edit
    @user = current_user
    @user.city ||= City.new
    @user.new_country_cd = @user.city.country_cd if @user.city
  end

  def create
    if valid_captcha?(params[:captcha])
      # remove all other pending activations
      User.where(activation_state: 'pending', email: params[:user][:email]).delete_all
      @user = User.new(params[:user])
      @user.save!
      head :ok
    else
      render partial: 'shared/auth_block', status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    params[:user].delete(:city_id) if params[:user][:city_id] == '-1'
    @user.update_attributes!(params[:user])
    redirect_to edit_user_path
  end

  def ensure_name
    respond_to do |format|
      format.json do
        render json: { free: current_user.free_name?(params[:name]) }
      end
    end
  end

  def ensure_email
    respond_to do |format|
      format.json do
        render json: { used: User.where(email: params[:email]).any? }
      end
    end
  end

  def update_email
    @user = current_user
    @user.email = params[:email]
    @user.save!
    head :ok
  end
  
  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      auto_login(@user)
      redirect_to root_path
    else
      not_authenticated
    end
  end

  def oauth
    login_at(params[:provider])
  end

  # OAuth callback
  def oauth_callback
    if @user = login_from(params[:provider])
      auto_login(@user)
      redirect_back_or_to root_path
    else
      @user = create_from(params[:provider])
      @user.save!
      @user.activate!
      reset_session # protect from session fixation attack
      auto_login(@user)
      redirect_back_or_to root_path
    end
  end
end
