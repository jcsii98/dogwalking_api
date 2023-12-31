Rails.application.routes.draw do
  
  mount_devise_token_auth_for 'User', at: 'auth', controllers: { confirmations: 'users/confirmations' }

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

  resources :dog_walking_jobs do
    resources :schedules
  end

  patch '/dog_walking_job', to: 'dog_walking_jobs#update'
  delete '/dog_walking_job', to: 'dog_walking_jobs#destroy'

  resources :bookings, only: [:index, :create, :show, :update, :destroy] do
    resource :chatroom, only: [:show] do
      post 'messages', to: 'chatrooms#create_message'
    end
  end

  get '/user_search', to: 'users_search#index', as: 'user_search'

  mount ActionCable.server => '/cable'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
