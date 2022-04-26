Rails.application.routes.draw do
  namespace :api do
    resources :users, only: [] do
      get :current_user, action: :show, on: :collection
    end
  end
end
