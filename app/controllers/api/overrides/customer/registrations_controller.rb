module Api
  module Overrides
    module Customer
      class RegistrationsController < DeviseTokenAuth::RegistrationsController
        before_action :configure_permitted_parameters
        before_action :password_check, only: [:update]
      
        def render_create_success
          render json: {
            status: 'success',
            message: '入力いただいたメールアドレスに確認メールを送付いたしました。',
            data:   resource_data
          }
        end

        def show
          @user = User.find(current_user.id)
          render json: @user
        end
        
        def update
          @user = User.find(current_user.id)
          if @user.update(update_params)
          else
            @user.update(update_params)
            render status: 401, json: { errors: @user.errors.full_messages }
          end
        end

        protected
        
        def password_check
          if (params[:current_password]).present?
            @user = User.find(current_user.id)
           unless @user.valid_password?(params[:current_password])
            render_error(401, I18n.t('errors.messages.validate_account_update_params'))
           end
          end
        end
        
        def update_params
          params.permit(:phone_number, :name, :post_code, :address,:email)
        end

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
end
