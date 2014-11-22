Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root "static_pages#front"

  get   '/sign_in', to: "sessions#new"
  post  '/sign_in', to: "sessions#create"
  get   '/register', to: "users#new"

  get 'home', to: "categories#index"

  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: "videos#search"
    end
  end
  resources :users, only: [:create]
end
