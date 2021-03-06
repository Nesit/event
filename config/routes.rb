EventRu::Application.routes.draw do
  captcha_route

  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config
  resources :menu_items, only: [:new]
  resources :tags, only: [:index]

  [ 'company', 'event', 'interview', 'news',
    'overview', 'report', 'trip', 'detail'
  ].each do |kind|
    resources :"#{kind}_articles",
      controller: :articles,
      path: kind.pluralize,
      only: [:index, :show],
      defaults: { type: "#{kind.camelize}Article" } do
      get 'preview', on: :member
    end
  end
  resources :"tv_articles",
    controller: :articles,
    path: 'tv',
    only: [:index, :show],
    defaults: { type: "TvArticle" } do
    get 'preview', on: :member
    end

  resources :polls, only: [:index, :show] do
    resources :poll_votes, path: :votes, only: [:create]
  end

  resources :shares, only: [:create]
  resources :comments, only: [:create, :index, :update, :destroy]
  resources :cities, only: [:index]
  resources :pages, only: [:show]
  resources :article_galleries, only: [:show]
  resources :subscriptions, only: [:new, :create, :destroy] do
    get 'pay'
  end

  # allow to use /articles only with tag_id param
  # to do not dubplicate home page functionality
  get 'articles' => 'articles#index',
    constraints: lambda { |req| req.params[:tag_id].present? }
  get 'articles/search' => 'articles#search',
    constraints: lambda { |req| req.params[:term].present? }

  post 'sessions' => 'user_sessions#create', as: :user_session
  delete 'sessions' => 'user_sessions#destroy', as: :user_session

  resources :users, only: [:create, :destroy]

  get 'profile' => 'users#edit', as: :edit_user
  put 'profile' => 'users#update', as: :user
  get 'profile/subscriptions' => 'subscriptions#index', as: :user_subscriptions
  get 'profile/notifications' => 'notifications#index', as: :user_notifications
  get 'profile/name' => 'users#ensure_name', as: :ensure_user_name
  get 'profile/email' => 'users#ensure_email', as: :ensure_user_email
  put 'profile/email' => 'users#update_email', as: :update_user_email
  get 'profile/password' => 'users#edit_password', as: :profile_password
  post 'profile/password' => 'users#update_password'
  get 'profile/avatar' => 'users#edit_avatar', as: :profile_avatar
  post 'profile/avatar' => 'users#update_avatar'

  resources :temporary_avatars, only: [:create]

  get 'users/oauth' => 'users#oauth', as: :oauth_login
  get 'users/activate' => 'users#activate', as: :activate_user
  get 'users/merge' => 'users#merge', as: :merge_user
  post 'users/merge' => 'users#create_merge_request'
  get 'users/callback' => 'users#oauth_callback'

  resources :password_resets, only: [:create, :edit, :update]

  resources :robokassa_payments, only: [] do
    collection do
      get 'paid'
      get 'success'
      get 'fail'
    end
  end

  root to: 'home#show'

  # to make exception notifier silent for /none.png requests
  match 'none' => 'home#none'
  
  match '*any' => 'home#page404'
end
