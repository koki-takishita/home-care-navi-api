class Api::UsersController < ApplicationController
  def create
    user = User.new(user_params)
    if user.valid?
      user.save!
      render json: { status: 'success' }
    else
      puts user.errors.full_messages
      render json: user.errors.full_messages, status: 400
    end
  end

  def index
    render json: user.errors.full_messages, status: 400
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
