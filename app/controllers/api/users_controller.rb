class Api::UsersController < ApplicationController
  before_action :authenticate_user

  def create
    user = User.new(user_params)
    if user.valid?
      user.save!
      render json: { status: 'success' }
    else
      render json: { status: user.errors.full_messages }
    end
  end

  def show
    render json: current_user.my_json
  end

  private

    def user_params
      params.require(:user).permit(:name,
                                   :email,
                                   :password,
                                   :password_confirmation,
                                   :phone_number,
                                   :post_code,
                                   :address)
    end
end
