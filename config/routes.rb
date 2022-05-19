Rails.application.routes.draw do
  namespace :api do
    resources :offices, only: [:index, :show]
    namespace :specialists do
      resources :staffs, only: [:create]
    end
  end
  mount_devise_token_auth_for 'User', at: 'api/users', skip: [:omniauth_callbacks], controllers: {
    registrations: 'api/overrides/registrations'
  }
  devise_scope :user do
    post 'api/specialists/users', to: 'api/overrides/specialist_registrations#create'
  end
end
