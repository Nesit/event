class Ability
  include CanCan::Ability

  def initialize(user, admin_user)
    
    if admin_user.present?
      can :new, :menu_item
      can :index, :tag
    end

    # for guest

    can :show, :home
    can :none, :home
    can :page404, :home

    # to be able log in
    can :create, :user_session

    # be able to reset password
    can [:create, :edit, :update], :password_reset

    # to log in through OAuth, activate from email
    can [
      :create, :activate, :merge, :create_merge_request, :oauth,
      :oauth_callback, :ensure_email
      ], User

    can [:read, :search], Article
    can :preview, Article if admin_user
    can :read, ArticleGallery # for dynamic embedding images galleries
    can :read, Comment
    can :read, Poll

    # increase social shares counter
    can :create, :share

    can :read, Page

    can [:new, :create, :pay], Subscription
    can [:success, :fail], :robokassa_payment

    can [:edit], User

    return if user.blank?

    can [:update_email], User if user.email.blank?

    # now for registered user
    can :manage, PollVote

    # to be able log out
    can :destroy, :user_session

    # for profile
    can :read, City
    can :manage, Subscription
    can :read, :notification
    can [:update, :ensure_name, :edit_password, :update_password], User
    can [:edit_avatar, :update_avatar], User
    can :create, TemporaryAvatar

    if user.complete?
      can [:create, :update, :destroy], Comment
    end
  end
end
