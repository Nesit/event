class ::ApplicationController < ActionController::Base
  before_filter :put_captcha_into_cookies

  def put_captcha_into_cookies
    if cookies[:force_captcha]
      puts "session captcha: #{sessions[:captcha]}"
      params[:captcha] = session[:captcha]
      puts "force #{cookies[:force_captcha]}"
      #session[:captcha] = cookies[:force_captcha]
      cookies.delete :force_captcha
    end
  end
end