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

        def show
          @user = User.find(current_user.id)
          render json: @user
        end

        def password_check
          if (params[:current_password]).present?
            @user = User.find(current_user.id)
          unless @user.valid_password?(params[:current_password])
            render json: {
              message: 'パスワードが違います',
              errors: ["パスワードが違います"],
            }, status: 401
          end
          end
        end

        def update  
          @user = User.find(current_user.id)
          if @user.update(update_params)
             render json: { status: 'success' }
          else
            @user.update(update_params)
            render status: 401, json: { errors: @user.errors.full_messages }
          end
        end

        def destroy
          if @resource
            @resource.destroy
            yield @resource if block_given?
            render_destroy_success
          else
            render_destroy_error
          end
        end

        protected
        
        def update_params
          params.permit(:phone_number, :name, :post_code, :address,:email,:password,:redirect_url)
        end

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
