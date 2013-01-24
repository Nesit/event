class SharesController < ApplicationController
  authorize_resource class: false

  before_filter :detect_subject

  def create
    unless params[:social].in? ['vk', 'fb', 'twitter', 'gplus', 'mailru']
      raise "wrong social kind"
    end

    sym = "#{params[:social]}_shares_count"
    @subject.send("#{sym}=", @subject.send(sym) + 1)
    @subject.save!
    head :ok
  end

  private

  def detect_subject
    @subject =
      case 
      when params[:kind].constantize.superclass == Article
        Article.find(params[:id])
      when params[:kind] == 'Poll'
        Poll.find(params[:id])
      end
  end
end
