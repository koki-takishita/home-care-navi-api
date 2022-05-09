Rails.application.routes.draw do
  namespace :api do
    resources :offices, only: [:create, :index]
  end
  mount_devise_token_auth_for 'User', at: 'api/users', skip: [:omniauth_callbacks], controllers: {
    registrations: 'api/overrides/registrations'
  }
end
