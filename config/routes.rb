Rails.application.routes.draw do
  root "home#index"

  # Public magazine routes
  resources :articles, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :tags, only: [:index, :show]

  # Admin section
  namespace :admin do
    root "dashboard#index"
    resources :articles do
      member do
        delete :purge_image
      end
    end
    resources :categories
    resources :tags, only: [:index, :new, :create, :destroy]
    resources :media, only: [:index, :destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
