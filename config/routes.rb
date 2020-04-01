Rails.application.routes.draw do
  root 'posts#index'
  resources :posts
  resources :comments, only: %i[create destroy]
  resources :users, only: %i[show edit update]
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    get 'signup', to: 'users/registrations#new'
    get 'login', to: 'users/sessions#new'
    get 'logout', to: 'users/sessions#destroy'
  end
end
