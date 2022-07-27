Rails.application.routes.draw do

  mount_devise_token_auth_for "Specialist", at: 'api/specialists/users', skip: [:omniauth_callbacks, :sessions, :token_validations, :password], controllers: {
    registrations: 'api/overrides/specialist/specialist_registrations'
  }
  mount_devise_token_auth_for "Customer", at: 'api/customer', skip: [:omniauth_callbacks, :sessions, :token_validations, :password], controllers: {
    registrations: 'api/overrides/customer/registrations'
  }
  mount_devise_token_auth_for "User", at: 'api/users',  skip: [:registrations, :omniauth_callbacks, :sessions, :token_validations, :password, :confirmations]

  devise_scope :user do
    post   'api/login',  to: 'api/overrides/customer/sessions#create'
    delete 'api/logout', to: 'devise_token_auth/sessions#destroy'
  end

  namespace :api do
    resources :contacts, only: [:create]
    get '/appointments', to: 'customer/appointments#index'
    scope module: :customer do
      resources :offices, only: [:index, :show] do
        resources :thanks, only: [:create], controller: 'thanks'
        resources :appointments, only: [:create]
        resources :bookmarks, only: [:create, :destroy, :index]
      end
      resources :thanks, only: [:index, :show, :update, :destroy]
    end
  end

  namespace :api do
    resource :specialists do
      resources :offices ,controller: 'specialists/offices' do
        resources :staffs, controller: 'specialists/staffs', only: [:index, :show, :create, :update, :destroy]
        resources :care_recipients, controller: 'specialists/care_recipients', only: [:index, :create, :show, :update, :destroy]
        resources :appointments, controller: 'specialists/appointments', only: [:index, :update, :destroy]
      end
    end
  end
end
