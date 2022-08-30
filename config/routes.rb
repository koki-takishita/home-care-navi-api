Rails.application.routes.draw do
  mount_devise_token_auth_for 'Specialist', at: 'api/specialists/users', skip: %i[omniauth_callbacks sessions token_validations password], controllers: {
    registrations: 'api/overrides/specialist/specialist_registrations'
  }
  mount_devise_token_auth_for 'Customer', at: 'api/customer', skip: %i[omniauth_callbacks sessions token_validations password], controllers: {
    registrations: 'api/overrides/customer/registrations'
  }

  mount_devise_token_auth_for 'User', at: 'api/users',
                                      skip: %i[registrations omniauth_callbacks sessions token_validations confirmations password]

  devise_for :users, controllers: { confirmations: 'confirmations' }

  devise_scope :user do
    post    'api/login',  to: 'api/overrides/customer/sessions#create'
    delete  'api/logout', to: 'devise_token_auth/sessions#destroy'
    post    'api/users',  to: 'api/overrides/customer/registrations#password_check'
    get     'api/users',  to: 'api/overrides/customer/registrations#show'
    delete  'api/users',  to: 'api/overrides/customer/registrations#destroy'
    post    'api/reset-password', to: 'api/overrides/reset_passwords#create'
    put     'api/reset-password', to: 'api/overrides/reset_passwords#update'
    get     'api/reset-password/edit', to: 'api/overrides/reset_passwords#edit'
  end

  namespace :api do
    resources :contacts, only: [:create]
    get '/appointments',       to: 'customer/appointments#index'
    get '/bookmarks',          to: 'customer/bookmarks#index'
    get '/histories',          to: 'customer/histories#index'
    get '/check-phone-number', to: 'check#check_phone_number'
    scope module: :customer do
      resources :offices, only: %i[index show] do
        resources :thanks, only: [:create], controller: 'thanks'
        resources :appointments, only: [:create]
        resources :bookmarks, only: %i[create destroy]
        resources :histories, only: %i[create update]
      end
      resources :thanks, only: %i[index show update destroy]
    end
  end

  namespace :api do
    resource :specialists do
      resource :offices, controller: 'specialists/offices' do
        resources :staffs, controller: 'specialists/staffs', only: %i[index show create update destroy]
        resources :care_recipients, controller: 'specialists/care_recipients', only: %i[index create show update destroy]
        resources :appointments, controller: 'specialists/appointments', only: %i[index update destroy]
        resources :thanks, controller: 'specialists/thanks', only: %i[index destroy]
      end
    end
  end
end
