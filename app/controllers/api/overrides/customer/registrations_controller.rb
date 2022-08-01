module Api
  module Overrides
    module Customer
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        before_action :configure_permitted_parameters
        before_action :set_redirect_url, only: [:update]
      
        def render_create_success
          render json: {
            status: 'success',
            message: '入力いただいたメールアドレスに確認メールを送付いたしました。',
            data:   resource_data
          }
        end

        protected
      
        def configure_permitted_parameters
          devise_parameter_sanitizer.permit(:sign_up, keys: %i( name 
                                                                phone_number
                                                                post_code
                                                                address
                                                                default_confirm_success_url)
          )
        end

        def set_redirect_url
          @resource.redirect_url = params[:redirect_url] if @resource
        end
      end
    end
  end
end
