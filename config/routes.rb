GameDay::Application.routes.draw do
  devise_for :users, path: ""
  match "user_root" => "home#index", :path => ""

  resources :users, only: [:show]
  get "/standings" => "teams#index"

  get "/:abbrev" => "teams#show", as: "team"

  root to: "home#index"
end
