Rails.application.routes.draw do
  root "home#index"

  resources :articles
  resources :categories

  get "up" => "rails/health#show", as: :rails_health_check
end
