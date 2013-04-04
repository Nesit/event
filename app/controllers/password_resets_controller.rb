class PasswordResetsController < ApplicationController
  authorize_resource class: false

  def create
    @user = User.find_by_email(params[:email])
    @user.deliver_reset_password_instructions! if @user.present?
        
    # Tell the user instructions have been sent whether or not email was found.
    # This is to not leak information to attackers about which emails exist in the system.
    head :ok
  end

  def edit
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    raise ActiveRecord::RecordNotFound if @user.blank?
  end

  def update
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    raise ActiveRecord::RecordNotFound if @user.blank?

    # for validation
    @user.password_confirmation = params[:user][:password_confirmation]

    if @user.change_password!(params[:user][:password])
      auto_login(@user)
      redirect_to root_path
    else
      render action: "edit"
    end
  end
end
