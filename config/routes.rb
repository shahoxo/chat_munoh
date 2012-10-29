ChatMunoh::Application.routes.draw do
  get "phrases/index"

  get "phrases/new"

  get "phrases/edit"

  resources :munohs
  resources :rooms do
    resources :talks
  end
  match "/auth/:provider/callback" => "sessions#create"
  match "/signout" => "sessions#destroy", :as => :signout
  root :to => "sessions#new"
end
