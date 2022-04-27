Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create]
    resources :auth_token, only: [:create] do
      post :refresh, on: :collection
      delete :destory, on: :collection
    end
  end
end
