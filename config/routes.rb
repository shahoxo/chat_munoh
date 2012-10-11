ChatMunoh::Application.routes.draw do
  resources :sessions , only: :new 
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  root :to => "sessions#new"
end
