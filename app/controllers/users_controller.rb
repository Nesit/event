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
    if User.activated.where(email: params[:email]).any?
      render json: {used: true}, status: :error
    else
      @user.email = params[:email]
      @user.instance_exec { setup_activation }
      @user.save!
      head :ok
    end
  end
  
  def activate
    if @user = User.load_from_activation_token(params[:token])
      @user.activate!
      auto_login(@user)
      redirect_to root_path
    else
      raise "activation token expired or invalid"
    end
  end

  def create_merge_request
    @user = current_user
    @user.setup_record_merge!(params[:email])
    head :ok
  end

  def merge
    if @user = User.load_from_merge_token(params[:token])
      @user.merge_with_other!

      # because user cames from email, so it belongs to him
      @user.activate! if @user.activation_state != 'active'

      auto_login(@user)
      redirect_to root_path
    else
      raise "merge token expired or invalid"
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
      previous_user = nil
      @user = create_from(params[:provider]) do |user|
        if user.valid? # service provides email, and it was unique, all is ok
          true
        elsif user.email.blank?
          # email is blank and user will get email request dialog,
          # so problem with email collision will be solved later
          true
        else
          # account with this email is already exists
          previous_user = User.where(email: @user.email).first

          # if registered account still doesn't activated via email
          # and doesn't binded to any of the social network
          # then probably specified email doesn't belong to that user
          # or belongs to this person. Anyway, can be safely removed
          if previous_user.activation_state == 'pending' and not previous_user.authentications.any?
            previous_user.destroy
            previous_user = nil
            true
          else
            # we need to copy sensetive data from here
            # and skip creation of this account
            previous_user.name ||= @user.name

            provider_name = params[:provider].to_sym
            provider = Sorcery::Controller::Config.send(provider_name)
            user_hash = provider.get_user_hash

            # provider_name and user_hash variables are defined in create_from method in sorcery
            previous_user.authentications.create!(provider: provider_name, uid: user_hash[:uid])
            false # do not create social user account, we already copied all info
          end
        end
      end

      # if there were previous user,
      # then that means that we didn't created new account
      # just updated old one
      unless previous_user.nil?
        @user = previous_user
      end

      # sorcery send email only if crypted password present
      # therefore it doesn't sends at first time
      #
      # stupid, but we need to call it twice to make it send email
      # with our new generated password (in User activate! method)
      if @user.activation_state != 'active'
        @user.activate!
        @user.activate!
      end

      @user.save!
      
      reset_session # protect from session fixation attack
      auto_login(@user)
      redirect_back_or_to root_path
    end
  end
end
