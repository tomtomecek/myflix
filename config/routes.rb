Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: "categories#index"
  resources :categories, only: [:show]
  resources :videos, only: [:show] do
    collection do
      get 'search', to: "videos#search"
    end
  end
end
