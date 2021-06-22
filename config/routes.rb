require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'lists#index'

  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
authenticate :user, lambda { |u| u.admin? } do
  mount Sidekiq::Web => '/sidekiq'

  namespace :madmin do
  end
end

  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :cards do
    member do
      patch :move
    end
  end
  
  resources :lists do
    member do
      patch :move
    end
  end
end
