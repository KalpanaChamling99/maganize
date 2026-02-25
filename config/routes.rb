Rails.application.routes.draw do
  root "home#index"

  # Public magazine routes
  resources :articles, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :tags, only: [:index, :show]
  resources :team_members, only: [:show]

  # Static pages
  get "about",     to: "pages#about",     as: :about
  get "contact",   to: "pages#contact",   as: :contact
  get "portfolio", to: "pages#portfolio", as: :portfolio

  # Public collections
  resources :collections, only: [:index, :show]

  # Admin section
  namespace :admin do
    get    "login",  to: "sessions#new",     as: :login
    post   "login",  to: "sessions#create"
    delete "logout", to: "sessions#destroy", as: :logout

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
    resources :roles, only: [:index, :new, :create, :edit, :update]
    resource  :settings, only: [:show, :update]
    resource  :profile,  only: [:show, :update]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
