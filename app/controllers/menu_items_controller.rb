class MenuItemsController < ApplicationController
  authorize_resource class: false
  include MenuHelper

  # reads url and returns menu item in json format
  def new
    @result = read_menu_item(params[:url])
    render json: item_for_form(@result)
  end
end
