class Api::OfficesController < ApplicationController
  before_action :set_office, only: [:show]
  before_action :authenticate_specialist!

  def index
    offices = Office.all
    render json:offices.as_json{ :offices }
  end

  def show
    render json:@office.as_json{ :@office }
  end

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

    def set_office
      @office = Office.find(params[:id])
    end
end
