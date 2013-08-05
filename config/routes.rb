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

  get "/:abbrev" => "teams#show", as: "team"
  post "/:abbrev/fav" => "team_favorites#create", as: "team_favorites"
  delete "/:abbrev/fav" => "team_favorites#destroy", as: "team_favorites"

  root to: "home#index"
end
