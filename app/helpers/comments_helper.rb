module CommentsHelper
  def can_comment?
    current_user and current_user.complete?
  end
end