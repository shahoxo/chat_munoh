ChatMunoh::Application.routes.draw do
  get "munoh/index"
  root :to => "sessions#login"
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
end
