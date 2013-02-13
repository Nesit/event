class Ability
  include CanCan::Ability

  def initialize(user, admin_user)
    
    if admin_user.present?
      can :new, :menu_item
    end

    # for guest

    can :show, :home
    can :none, :home
    can :page404, :home

    # to be able log in
    can :create, :user_session

    # to log in through OAuth, activate from email
    can [
      :create, :activate, :merge, :create_merge_request, :oauth,
      :oauth_callback, :ensure_email
      ], User

    can :read, Article
    can :preview, Article if admin_user
    can :read, ArticleGallery # for dynamic embedding images galleries
    can :read, Comment
    can :read, Poll

    # increase social shares counter
    can :create, :share

    can :read, Page

    can [:new, :create, :pay], Subscription
    can [:success, :fail], :robokassa_payment

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
    can [:edit, :update, :ensure_name], User

    if user.complete?
      can :create, Comment
    end
  end
end
