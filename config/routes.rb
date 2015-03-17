Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users
  resources :users
  namespace :admin do
    resources :users
  end
end
