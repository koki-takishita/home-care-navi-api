class Api::Customer::ThanksController < ApplicationController
  before_action :authenticate_customer!

  def create
    customer = current_customer
    thank = customer.thanks.build(thank_params)
    if(thank.valid?)
      thank.save!
      render json: {
        status: 'success',
        message: 'お礼作成に成功しました'
      }
    else
      render json: {
        status: 'danger',
        message: 'お礼作成に失敗しました'
      }
    end
  end

  private

  def thank_params
    params.require(:thank).permit(:comments, :office_id, :staff_id)
  end

end
