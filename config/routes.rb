Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users
  resources :users
  resources :exams
  namespace :admin do
    resources :users
    resources :subjects
  end
end
