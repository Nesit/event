class PagesController < ApplicationController
  authorize_resource

  def show
    @page = Page.find(extract_id_from_slug(params[:id]))
  end
end
