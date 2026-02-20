Rails.application.routes.draw do
  root "home#index"

  # Public magazine routes
  resources :articles, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :tags, only: [:index, :show]

  # Admin section
  namespace :admin do
    root "dashboard#index"
    resources :articles
    resources :categories
    resources :tags, only: [:index, :new, :create, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
