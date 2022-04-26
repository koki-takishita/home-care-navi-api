Rails.application.routes.draw do
  get 'users/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  # Defines the root path route ("/")
  # root "articles#index"
end
