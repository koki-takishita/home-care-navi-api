Rails.application.routes.draw do
  namespace :api do
    resources :offices, only: [:index, :show]
  end
  mount_devise_token_auth_for 'User', at: 'api/users', skip: [:omniauth_callbacks], controllers: {
    registrations: 'api/overrides/registrations'
  }
  devise_scope :user do
    post 'api/specialists/users', to: 'api/overrides/specialist_registrations#create'
  end

  resource :contacts, only: [:new, :create] do
    get "/success" => "contacts#success"
   end

end
