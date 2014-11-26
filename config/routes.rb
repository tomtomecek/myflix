Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root "static_pages#front"

  get   '/sign_in', to: "sessions#new"
  post  '/sign_in', to: "sessions#create"
  get   '/sign_out', to: "sessions#destroy"
  get   '/register', to: "users#new"
  
  get   '/my_queue', to: "queue_items#index"

  get 'home', to: "categories#index"


  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :users, only: [:create]
  resources :queue_items, only: [:create]
end
