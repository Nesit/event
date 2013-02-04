class PollVotesController < ApplicationController
  authorize_resource

  def create
    poll_id = extract_id_from_slug(params[:poll_id])
    PollVote.where(poll_id: poll_id, user_id: current_user.id).delete_all
    @vote = PollVote.new
    @vote.poll_choice_id = params[:poll_vote][:poll_choice_id]
    @vote.poll_id = poll_id
    @vote.user_id = current_user.id
    @vote.save!

    if params[:aside]
      render partial: 'polls/aside_result', locals: { poll: @vote.poll }
    else
      redirect_to @vote.poll
    end
  end
end
