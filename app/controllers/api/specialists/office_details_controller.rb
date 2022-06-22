class Api::Specialists::OfficeDetailsController < ApplicationController
  before_action :authenticate_specialist!

  def create
    office_details = Office_Details.new(office_details_params)
    if office_details.valid?
      office_details.save!
      render json: { status: 200}
    else
      render status: 401, json: { errors: office_details.errors.full_messages }
    end
  end

  private
    def office_details_params
      params.permit(:office_id, :detail, :service_type, :open_date, :rooms, :requirement, :facility, :management, :link)
    end
end
