module Api
  module Overrides
    module Specialist
      class SpecialistSessionsController < DeviseTokenAuth::SessionsController
        before_action  :exclusion_login_customer
        
        private

        def  exclusion_login_customer
          user = User.find_by(email: params[:email])
          render_create_error_forbidden if user && user.customer?
        end
        

        def render_create_error_forbidden
          render_error(401, I18n.t('devise_token_auth.sessions.bad_credentials'))
        end

      end
    end
  end
end