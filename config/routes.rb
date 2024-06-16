Rails.application.routes.draw do
  resources :teams
  resources :credentials
  resources :users
  get 'users/gpg_show/:id' => 'users#gpg_show', as: :users_gpg_show
  post 'users/gpg_update/:id' => 'users#gpg_update', as: :users_gpg_update
  delete 'users/gpg_destroy/:id' => 'users#gpg_destroy', as: :users_gpg_destroy
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "users#index"
end
