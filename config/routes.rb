GameDay::Application.routes.draw do
  devise_for :users, path: ""
  match "user_root" => "home#index", :path => ""

  resources :users, only: [:show]
  get "/standings" => "teams#index"
  resources :players, only: :index
  resources :players, only: :show do
    post "fav" => "player_favorites#create"
    delete "fav" => "player_favorites#destroy"
  end
  resources :goalies, only: :index
  resources :goalies, only: :show, as: "goalie" do
    post "fav" => "goalie_favorites#create", as: "fav"
    delete "fav" => "goalie_favorites#destroy"
  end
  resources :games, only: [:index, :show]

  resources :teams, only: :show, path: "" do
    resources :games, only: [:index]
    post "fav" => "team_favorites#create", as: "fav"
    delete "fav" => "team_favorites#destroy"
  end

  root to: "home#index"
end
