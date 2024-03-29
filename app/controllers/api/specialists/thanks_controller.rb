class Api::Specialists::ThanksController < ApplicationController
  before_action :authenticate_specialist!

  def index
    office_id = current_specialist.office.id
    # office_idに紐づくお礼のリストを、update_atの大きい順に取得
    thank_list = Thank.thank_list_of_office(office_id)
    # ページネーション対応ver
    thanks = thank_list.limit(10).offset(params[:page].to_i * 10)
    # お礼の全件の数
    thank_list_total = thank_list.count
    render json: {
      thanks: thanks,
      thank_total: thank_list_total
    }
  end

  def destroy
    thank = current_specialist.office.thanks.find(params[:id])
    thank.destroy
    if thank.destroyed?
      render json: {
        message: 'お礼を削除しました',
      }, status: :ok
    else
      render json: {
        message: 'お礼削除に失敗しました',
        }
    end
  end

end
