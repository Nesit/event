class TemporaryAvatarsController < ApplicationController
  authorize_resource

  def create
    temp = TemporaryAvatar.create! avatar: params[:file]
    render json: {url: temp.avatar.url, id: temp.id}
  end
end
