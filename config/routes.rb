Rails.application.routes.draw do
  namespace :api do
    resources :offices, only: [:index, :show]
    namespace :specialists do
      resources :staffs, only: [:create]
    end
  end
  mount_devise_token_auth_for 'User', at: 'api/users', skip: [:omniauth_callbacks, :sessions], controllers: {

    registrations: 'api/overrides/registrations'
  }

  mount_devise_token_auth_for "Specialist", at: 'api/specialist'
  devise_scope :specialist do
    post 'api/specialists/users', to: 'api/overrides/specialist_registrations#create'
    post   'api/login',           to: 'devise_token_auth/sessions#create'
    delete 'api/logout',           to: 'devise_token_auth/sessions#destroy'
  end
  
  namespace :api do
    resources :offices, only: [:index, :show]
    resource :specialists do
      resources :offices ,controller: 'specialists/offices' do
        resources :staffs, controller: 'specialists/staffs', only: [:index, :create]
      end
    end
  end
end