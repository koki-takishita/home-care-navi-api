Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'api/users', skip: [:omniauth_callbacks]
end
