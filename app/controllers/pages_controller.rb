class PagesController < ApplicationController
  authorize_resource

  def show
    @page = Page.find(params[:id])
  end
end
