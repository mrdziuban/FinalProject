GameDay::Application.routes.draw do
  devise_for :users, path: ""
  match "user_root" => "home#index", :path => ""

  resources :users, only: [:show]
  get "/standings" => "teams#index"

  get "/:abbrev" => "teams#show", as: "team"
  post "/:abbrev/fav" => "team_favorites#create", as: "team_favorites"
  delete "/:abbrev/fav" => "team_favorites#destroy", as: "team_favorites"

  root to: "home#index"
end
