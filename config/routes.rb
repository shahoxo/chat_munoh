ChatMunoh::Application.routes.draw do
  get "munoh/index"
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  root :to => "sessions#new"
end
