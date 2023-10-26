Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  root to: 'home#index'
  resources :warehouses, except: [:index]
  resources :suppliers, except: [:destroy]
  resources :product_models, only: [:index, :new, :create, :show]
  resources :orders, only: [:new, :create, :show, :index, :edit, :update] do
    get 'search', on: :collection
    post 'delivered', on: :member
    post 'canceled', on: :member
  end
end
