module Api
  module Overrides
    class SpecialistRegistrationsController < DeviseTokenAuth::RegistrationsController
      before_action :configure_permitted_parameters
    
      def create
        super do |resource|
          user_type_specialist = puts resource.specialist!
        end
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
    end
  end
end