Myflix::Application.routes.draw do
  
  get '/sign_in', to: "sessions#new"
  post '/sign_in', to: "sessions#create"
  get '/sign_out', to: "sessions#destroy"

  get 'home', to: "categories#index"

  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: "videos#search"
    end
    resources :reviews, only: [:create]
  end

  resources :password_resets, only: [:new]

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
end
