class CitiesController < ApplicationController
  authorize_resource

  def index
    @cities = City.where(country_cd: params[:country_cd])
    respond_to do |format|
      format.json { render json: @cities }
    end
  end
end
