Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [:create] do
      get :current_user, action: :show, on: :collection
    end
    resources :users_token, only: [:create] do
      delete :destroy, on: :collection
    end
    get 'users_token/hello', to: 'users_token#hello'
  end
end
