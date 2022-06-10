class Api::Specialists::OfficesController < ApplicationController
  before_action :authenticate_specialist!

  def create
    params[:user_id] = current_specialist.id
    office = Office.new(office_params)
    if office.valid?
      office.save!
      render json: { status: 200}
    else
      render json: { status: office.errors.full_messages }
    end
  end

  private
  def office_params
    params.permit(:name, :title, :flags, :business_day_detail, :address, :post_code, :phone_number, :fax_number, :user_id, images: [])
  end
end
