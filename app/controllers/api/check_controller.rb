module Api
  class CheckController < ApplicationController

    def check_phone_number
      phone_number = params[:phone_number]
      res = !phone_number_exist?(phone_number)
      res ? render_create_success : render_error
    end

    private

    # User or Officeにphone_numberが存在するならtrue
    def phone_number_exist?(phone_number)
      Office.phone_number_exist?(phone_number).exists? || User.phone_number_exist?(phone_number).exists?
    end

    def render_create_success
      render json: {
        message: 'officeとusersテーブルに電話番号の重複はしていません。'
      }, status: :ok
    end

    def render_error
      render json: {
        message: '登録済みの電話番号です。',
      }, status: 403
    end
  end
end
