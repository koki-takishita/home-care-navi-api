module Api
  module Overrides
    class SpecialistRegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :configure_permitted_parameters
    
      protected
    
      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: %i( name 
    																													phone_number
    																													post_code
    																													address
    																												  default_confirm_success_url).merge
    		)
      end
    end
  end
end