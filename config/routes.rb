Rails.application.routes.draw do
  namespace :admin do
    root 'exams#index'
    resources :users
    resources :subjects, except: :edit
    resources :exams, only: [:index, :edit, :update]
  end
  
  root 'static_pages#home'
  devise_for :users
  resources :users, only: :show
  resources :exams, except: [:index, :new, :destroy]
end
