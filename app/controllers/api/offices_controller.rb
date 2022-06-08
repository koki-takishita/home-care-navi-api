class Api::OfficesController < ApplicationController
  before_action :set_office, only: [:show]

  def index
    offices = Office.all
=begin
{
  data: {
    office: {

      thank: {
        # ランダムに一つ
      }
      detail: {
        # 事業所の特徴
        # 画像
      }
    }
  }
}
=end
    render json:offices.as_json{ :offices }
  end

  def show
    render json:@office.as_json{ :@office }
  end

  private
   def set_office
      @office = Office.find(params[:id])
   end
end
