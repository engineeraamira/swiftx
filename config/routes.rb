Rails.application.routes.draw do
  resources :user_jogs
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#home"

  get 'add_user' => 'users#add_new'

  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      root 'users#homepage'
      resources :users
      resources :user_jogs
      post 'auth_user' => 'authentication#authenticate'
      post 'add_user' => 'users#add_user'

      
    end
  end

end
