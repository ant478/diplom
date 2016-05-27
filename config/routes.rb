Rails.application.routes.draw do
  namespace :api, defaults: {format: :json} do
    resources :users, only: [:index, :show, :create, :update, :destroy]
    resources :sessions, only: [:create, :destroy]
    resources :products, only: [:index, :show, :create, :update, :destroy]
    resources :categories, only: [:index, :show, :create, :update, :destroy]
    resources :deals, only: [:index, :show, :create]
    resources :transactions, only: [:index]
    resources :comments, only: [:index, :create, :destroy]
    resources :currencies, only: [:index]
  end
end
