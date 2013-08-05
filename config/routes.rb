GameDay::Application.routes.draw do
  devise_for :users, path: ""
  match "user_root" => "home#index", :path => ""

  resources :users, only: [:show]

  root to: "home#index"
end
