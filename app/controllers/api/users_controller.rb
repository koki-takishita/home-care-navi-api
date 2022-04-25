class Api::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 'success' }
    else
      render json: { status: 'danger' }
    end
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation,
                                   :phone_number,
                                   :post_code,
                                   :address,
                                   :user_type)
    end
end
