Rails.application.routes.draw do
  namespace :admin do
    root 'exams#index'
    resources :users
    resources :subjects
    resources :exams
  end
  
  root 'static_pages#home'
  devise_for :users
  resources :users
  resources :exams
end
