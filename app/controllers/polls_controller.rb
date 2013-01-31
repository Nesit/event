class PollsController < ApplicationController
  authorize_resource

  def index
    @polls = Poll.newer.page(params[:page]).per(3)
  end

  def show
    @poll = Poll.find(params[:id])
    @poll.record_pageview!
    seo_tags(@poll, title: :title)
  end
end
