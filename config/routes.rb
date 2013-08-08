GameDay::Application.routes.draw do
  devise_for :users, path: ""
  match "user_root" => "home#index", :path => ""

  resources :users, only: [:show]
  get "/standings" => "teams#index"
  resources :players, only: [:index, :show]

  resources :goalies, only: :index
  resources :goalies, only: :show, as: "goalie"

  resources :games, only: [:index, :show]

  resources :teams, only: :show, path: "" do
    resources :games, only: [:index]
  end

  resource :favorites, only: [:create, :destroy]

  root to: "home#index"
end
