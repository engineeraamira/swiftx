Rails.application.routes.draw do
  resources :user_jogs
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "users#home"

  get 'add_user' => 'users#add_new'

end
