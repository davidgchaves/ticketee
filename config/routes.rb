Rails.application.routes.draw do
  namespace :admin do
    resources :users
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root 'projects#index'

  resources :projects do
    resources :tickets
  end

  resources :users

  get "/signin", to: "sessions#new"
  post "/signin", to: "sessions#create"
end
