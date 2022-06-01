Rails.application.routes.draw do
  namespace :api do
    resources :offices, only: [:index, :show]
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
    post 'api/specialists/login', to: 'api/overrides/specialist/specialist_sessions#create'
    delete 'api/specialists/logout',  to: 'devise_token_auth/sessions#destroy'
  end
  
  namespace :api do
    resource :specialists do
      resources :offices ,controller: 'specialists/offices' do
        resources :staffs, controller: 'specialists/staffs', only: [:index, :show, :create, :update, :destroy]
      end
    end
  end
end
