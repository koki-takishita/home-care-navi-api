class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def show
    @office = current_specialist.office
    render json: @office
  end

  def create
    params[:user_id] = current_specialist.id
    office = Office.new(office_params)
    if office.valid?
      office.save!
      render json: { status: 200}
    else
      render status: 401, json: { errors: office.errors.full_messages }
    end
  end

  private
  def office_params
    params.permit(:name, :title, :flags, :business_day_detail, :address, :post_code, :phone_number, :fax_number, :user_id, images: [])
    params.require(:office).permit(:office_name, office_detail_attributes:
    [
      :office_detail_name, image_comments_attributes:
        [
          :image_comment_name
        ]
    ]
  )
  end
end


private
def office_params
  # formから送られてくるパラメータの取得（ストロングパラメーター）
  params.require(:office).permit(:office_name, office_detail_attributes:
    [
      :office_detail_name, image_comments_attributes:
        [
          :image_comment_name
        ]
    ]
  )
end


  def new
    # インスタンス作成
    @office = Office.new
    office_detail = @office.build_office_detail
    office_detail.image_comments.build
  end

  def create
    # 親子孫のデータの作成
    @office = Office.create(office_params)
  end


