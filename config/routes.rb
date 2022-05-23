Rails.application.routes.draw do

  mount_devise_token_auth_for 'User', at: 'api/users', skip: [:omniauth_callbacks], controllers: {
    registrations: 'api/overrides/registrations'
  }

  mount_devise_token_auth_for "Specialist", at: 'api/specialist'
  devise_scope :specialist do
    post 'api/specialists/users', to: 'api/overrides/specialist_registrations#create'
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