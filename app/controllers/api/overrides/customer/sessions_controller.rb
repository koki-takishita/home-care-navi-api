module Api
  module Overrides
    module Customer
      class SessionsController < DeviseTokenAuth::SessionsController
        before_action  :exclusion_login_specialist
        
        private

        def exclusion_login_specialist
          user = User.find_by(email: params[:email])
          render_create_error_forbidden if user && user.specialist?
        end
        

        def render_create_error_forbidden
          render_error(401, I18n.t('devise_token_auth.sessions.bad_credentials'))
        end

      end
    end
  end
end
