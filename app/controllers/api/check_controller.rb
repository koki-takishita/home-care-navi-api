module Api
  class CheckController < ApplicationController

    def check_phone_number
      phone_number = params[:phone_number]
      res = !phone_number_exist?(phone_number)
      res ? render_create_success : render_error
    end

    def check_fax_number
      fax_number = params[:fax_number]
      res = !fax_number_exist?(fax_number)
      res ? render_fax_create_success : render_fax_error
    end

    def check_fax_and_phone_number
      fax_number = params[:fax_number]
      res = !fax_and_phone_number_exist?(fax_number)
      res ? render_fax_only_create_success : render_fax_only_error
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

    # 他のOfficeのfax_numberと重複するならtrue
    def fax_number_exist?(fax_number)
      Office.fax_number_exist?(fax_number).exists?
    end

    def render_fax_create_success
      render json: {
        message: 'このFAX番号は他のofficeのFAX番号と重複はしていません。'
      }, status: :ok
    end

    def render_fax_error
      render json: {
        message: '他のofficeで登録済みのFAX番号です。',
      }, status: 403
    end

    # 他のOfficeのphone_numberがfax_numberと重複するならtrue
    def fax_and_phone_number_exist?(fax_number)
      Office.fax_number_exist?(fax_number).exists?
    end

    def render_fax_only_create_success
      render json: {
        message: '承認されました。このFAX番号は他のofficeの電話番号と重複はしていません。'
      }, status: :ok
    end

    def render_fax_only_error
      render json: {
        message: '無効となりました。このFAX番号は他のofficeが電話番号として既に登録しています。',
      }, status: 403
    end
  end
end
