GameDay::Application.routes.draw do
  devise_for :users, path: ""
  match "user_root" => "home#index", :path => ""
  post "/search" => "home#search", as: "search"
  get "/links" => "games#links"
  get "/links_json" => "games#links_json"

  resources :users, only: [:show, :update]
  get "/standings" => "teams#index"
  resources :players, only: [:index, :show]

  resources :goalies, only: :index
  resources :goalies, only: :show, as: "goalie"

  resources :games, only: [:index, :show]

  resources :analyses, except: [:new, :edit]
  resources :analyses, only: [:show] do
    get "/charts" => "analyses#charts"
  end

  resources :forums, only: [:index, :show] do
    resources :topics, except: [:index, :new, :edit], path: "" do
      resources :comments, only: [:create, :update]
    end
  end

  resources :comments, only: :destroy

  resources :teams, only: :show, path: "" do
    resources :games, only: [:index]
  end

  resource :favorites, only: [:create, :destroy]

  root to: "home#index"
end
