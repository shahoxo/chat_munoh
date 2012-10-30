ChatMunoh::Application.routes.draw do
  resources :munohs do
    resources :phrases
  end

  resources :rooms do
    resources :talks
  end
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  root :to => "sessions#new"
end
