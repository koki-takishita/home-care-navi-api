class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!,

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
    @office.build_office_detail
    if office_detail.valid?
      office_detail.save!
      render json: { status: 'success' }
    else
      render status: 401, json: { errors: office_detail.errors.full_messages }
    end
  end

  private

  def office_params
    params.require(:office).permit(:name, :title, :flags, :business_day_detail, :address, :post_code, :phone_number, :fax_number, :user_id, images: [], office_detail_attribute: [:id, :detail, :service_type, :open_date, :rooms, :requirement, :facility, :management, :link])
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
