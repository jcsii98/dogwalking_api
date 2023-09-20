Rails.application.routes.draw do
  
  mount_devise_token_auth_for 'User', at: 'auth'

  mount_devise_token_auth_for 'Admin', at: 'admin_auth'
  as :admin do
    # Define routes for Admin within this block.
  end

  namespace :admin do
    resources :users, only: [:index, :show]
    resources :pending_users, only: [:index, :show, :update]
  end

  resource :user, only: [:show, :update]

  resources :dog_profiles
  resources :dog_walking_jobs

  get '/user_search', to: 'users_search#index', as: 'user_search'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
