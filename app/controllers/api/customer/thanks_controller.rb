class Api::Customer::ThanksController < ApplicationController
  before_action :authenticate_customer!

  def create
    customer = current_customer
    thank = customer.thanks.build(thank_params)
    if(thank.valid?)
      thank.save!
      render json: {
        message: 'お礼作成に成功しました'
      }, status: :ok
    else
      render json: {
        message: 'お礼作成に失敗しました',
        errors: thank.errors.full_messages
      }, status: 403
    end
  end

  private

  def thank_params
    params.require(:thank).permit(:comments, :office_id, :staff_id)
  end

end
