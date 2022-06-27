module Api
  module Overrides
    module Customer
      class SessionsController < DeviseTokenAuth::SessionsController
        before_action  :configure_permitted_parameters
        before_action  :exclusion_login_specialist, if: -> { params[:user_type] == 'customer' }
        before_action  :exclusion_login_customer, if: -> { params[:user_type] == 'specialist' }
        after_action  :add_office_data, if: -> { params[:user_type] == 'specialist' }
       
        private

        def exclusion_login_specialist
          user = User.find_by(email: params[:email])
          render_create_error_forbidden if user && user.specialist?
        end

        def  exclusion_login_customer
          user = User.find_by(email: params[:email])
          render_create_error_forbidden if user && user.customer?
        end

        def  add_office_data
          user = User.find_by(email: params[:email])
          if user && !user.office.nil?
            response.headers['office_data'] = 'true'
          end
        end

        def render_create_error_forbidden
          render_error(401, I18n.t('devise_token_auth.sessions.bad_credentials'))
        end

        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_in, keys: %i( name 
                                                                password
                                                                user_type
                                                              )
          )
        end
      end
    end
  end
end
