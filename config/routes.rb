Myflix::Application.routes.draw do
  require 'sidekiq/web'

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/sign_out', to: "sessions#destroy"

  get '/password_reset', to: "password_resets#new"
  post '/password_reset', to: "password_resets#create"
  get '/confirm_password_reset', to: "password_resets#confirm"
  get '/password_reset/invalid_token', to: "password_resets#invalid_token", as: :invalid_token
  get '/password_reset/:token', to: "password_resets#edit", as: :reset_password
  patch '/password_reset', to: "password_resets#update", as: :update_password

  get 'home', to: "categories#index"

  resources :invitations, only: [:new, :create]

  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: "videos#search"
      get 'advanced_search', to: "videos#advanced_search", as: :advanced_search
    end
    resources :reviews, only: [:create]
  end

  get '/register', to: "users#new"
  resources :users, only: [:create, :show]

  get 'people', to: "relationships#index"
  resources :relationships, only: [:create, :destroy]

  get '/my_queue', to: "queue_items#index"
  resources :queue_items, only: [:create, :destroy] do
    collection do
      patch 'update_queue', to: "queue_items#update_queue", as: :update
    end
  end

  get 'ui(/:action)', controller: 'ui'
  root 'static_pages#front'
  mount StripeEvent::Engine, at: '/stripe_events'
  mount Sidekiq::Web, at: '/sidekiq'
end
