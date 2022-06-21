Rails.application.routes.draw do
  namespace :api do
    resources :contacts, only: [:create]
    resources :offices, only: [:index, :show]
    resources :offices do
      resources :appointments, controller: 'offices/appointments', only: [:create]
    end
  end

  mount_devise_token_auth_for 'User', at: 'api/users', skip: [:omniauth_callbacks, :sessions], controllers: {
    registrations: 'api/overrides/customer/registrations'
  }

  devise_scope :user do
    post   'api/login',           to: 'api/overrides/customer/sessions#create'
    delete 'api/logout',           to: 'devise_token_auth/sessions#destroy'
  end

  mount_devise_token_auth_for "Specialist", at: 'api/specialist'

  devise_scope :specialist do
    post 'api/specialists/users', to: 'api/overrides/specialist/specialist_registrations#create'
  end
  
  namespace :api do
    resource :specialists do
      resources :offices ,controller: 'specialists/offices' do
        resources :staffs, controller: 'specialists/staffs', only: [:index, :show, :create, :update, :destroy]
        resources :care_recipients, controller: 'specialists/care_recipients', only: [:index, :create, :show, :update, :destroy]
      end
    end
  end
end
