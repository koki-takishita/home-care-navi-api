Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create, :index]
  end
end
