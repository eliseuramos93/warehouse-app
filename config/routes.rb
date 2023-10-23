Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root to: 'home#index'
  resources :warehouses, except: [:index]
  resources :suppliers, except: [:destroy]
end
