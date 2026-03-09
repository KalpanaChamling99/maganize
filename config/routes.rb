Rails.application.routes.draw do
  root "home#index"

  # Public magazine routes
  resources :articles, only: [:index, :show] do
    resources :comments, only: [:create]
    resources :ratings, only: [:create, :update], controller: "article_ratings"
  end
  resources :comments, only: [:edit, :update] do
    resources :reactions, only: [:create], controller: "comment_reactions"
  end
  resources :categories, only: [:index, :show]
  resources :tags, only: [:index, :show]
  resources :team_members, only: [:show]

  # Static pages
  get "about",     to: "pages#about",     as: :about
  get "contact",   to: "pages#contact",   as: :contact
  get "portfolio", to: "pages#portfolio", as: :portfolio

  # Public collections
  resources :collections, only: [:index, :show]

  # Bookmarks (localStorage IDs passed as params; server-side rendered)
  get "bookmarks", to: "bookmarks#index", as: :bookmarks

  # Public user auth & profile
  get    "signup",  to: "users#new",            as: :user_signup
  post   "signup",  to: "users#create"
  get    "login",   to: "user_sessions#new",    as: :user_login
  post   "login",   to: "user_sessions#create"
  delete "logout",  to: "user_sessions#destroy", as: :user_logout
  get    "profile", to: "user_profile#edit",    as: :user_profile
  patch  "profile", to: "user_profile#update"

  # Admin section
  namespace :admin do
    get    "login",    to: "sessions#new",        as: :login
    post   "login",    to: "sessions#create"
    delete "logout",   to: "sessions#destroy",    as: :logout
    get    "register", to: "registrations#new",   as: :register
    post   "register", to: "registrations#create"

    root "dashboard#index"
    resources :articles do
      member do
        delete :purge_image
      end
    end
    resources :categories
    resources :tags, only: [:index, :new, :create, :destroy]
    resources :media, only: [:index, :destroy]
    resources :team_members
    resources :collections do
      member { delete :purge_cover }
    end
    resources :users
    resources :members, only: [:index, :destroy]
    resources :roles, only: [:index, :new, :create, :edit, :update]
    resource  :settings, only: [:show, :update]
    resource  :profile,  only: [:show, :update]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
